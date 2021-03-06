module EtsyApi

  # = Request
  #
  # A basic wrapper around GET requests to the Etsy JSON API
  #
  class Request

    # Perform a GET request for the resource with optional parameters - returns
    # A Response object with the payload data
    def self.get(resource_path, parameters = {})
      setup(parameters)
      request = EtsyApi::Request.new(resource_path, @@access.merge(:api_key => EtsyApi.api_key))
      Response.new(request.get(EtsyApi.access_token, EtsyApi.access_secret, EtsyApi.api_key, EtsyApi.api_secret))
    end

    def self.get_all(resource_path, parameters = {})
      setup(parameters)
      request = EtsyApi::Request.new(resource_path, @@access.merge(:api_key => EtsyApi.api_key))
      Response.new(request.get(EtsyApi.access_token, EtsyApi.access_secret, EtsyApi.api_key, EtsyApi.api_secret))
    end

    # https://openapi.etsy.com/v2/users/timothyf?api_key=qws5jsgknquo9ym7chkz1y36
    def self.get_user(user_id)
      setup
      request = Request.new('/users/' + user_id, @@access.merge(:api_key => EtsyApi.api_key))
      Response.new(request.get(EtsyApi.access_token, EtsyApi.access_secret, EtsyApi.api_key, EtsyApi.api_secret))
    end

    def self.post(resource_path, parameters = {})
      request = Request.new(resource_path, parameters)
      Response.new(request.post)
    end

    def self.put(resource_path, parameters = {})
      request = Request.new(resource_path, parameters)
      Response.new(request.put)
    end

    def self.delete(resource_path, parameters = {})
      request = Request.new(resource_path, parameters)
      Response.new(request.delete)
    end



    # Create a new request for the resource with optional parameters
    def initialize(resource_path, parameters = {})
      parameters = parameters.dup
      @token = parameters.delete(:access_token) || EtsyApi.credentials[:access_token]
      @secret = parameters.delete(:access_secret) || EtsyApi.credentials[:access_secret]
      raise("Secure connection required. Please provide your OAuth credentials via :access_token and :access_secret in the parameters") if parameters.delete(:require_secure) && !secure?
      @multipart_request = parameters.delete(:multipart)
      @resource_path = resource_path
      @resources = parameters.delete(:includes)
      if @resources.class == String
        @resources = @resources.split(',').map {|r| {:resource => r}}
      elsif @resources.class == Array
        @resources = @resources.map do |r|
          if r.class == String
            {:resource => r}
          else
            r
          end
        end
      end
      parameters = parameters.merge(:api_key => EtsyApi.api_key) unless secure?
      @parameters = parameters
    end

    def base_path # :nodoc:
      "/v2"
    end

    # Perform a GET request against the API endpoint and return the raw
    # response data
    def get(access_token, access_secret, api_key, api_secret)
      # client.get(endpoint_url)
      client = OAuth::AccessToken.new(consumer(api_key, api_secret), access_token, access_secret)
      result = client.get(endpoint_url)
      {:body => result.body, :code => result.code}
    end

    def post
      if multipart?
        client.post_multipart(endpoint_url(:include_query => false), @parameters)
      else
        client.post(endpoint_url)
      end
    end

    def put
      client.put(endpoint_url)
    end

    def delete
      client.delete(endpoint_url)
    end

    def client # :nodoc:
      @client ||= secure? ? secure_client : basic_client
    end

    def parameters # :nodoc:
      @parameters
    end

    def resources # :nodoc:
      @resources
    end

    def query # :nodoc:
      to_url(parameters.merge(:includes => resources.to_a.map { |r| association(r) }))
    end

    def to_url(val)
      if val.is_a? Array
        to_url(val.join(','))
      elsif val.is_a? Hash
        val.reject { |k, v|
          k.nil? || v.nil? || (k.respond_to?(:empty?) && k.empty?) || (v.respond_to?(:empty?) && v.empty?)
        }.map { |k, v| "#{to_url(k.to_s)}=#{to_url(v)}" }.join('&')
      else
        URI.escape(val.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
      end
    end

    def association(options={}) # :nodoc:
      s = options[:resource].dup

      if options.include? :fields
        s << "(#{[options[:fields]].flatten.join(',')})"
      end

      if options.include?(:limit) || options.include?(:offset)
        s << ":#{options.fetch(:limit, 25)}:#{options.fetch(:offset, 0)}"
      end

      s
    end

    def endpoint_url(options = {}) # :nodoc:
      url = "#{base_path}#{@resource_path}"
      url += "?#{query}" if options.fetch(:include_query, true)
      url
    end

    def multipart?
      !!@multipart_request
    end

    private

    def self.setup(parameters)
      #@@access = {:access_token => parameters[:access_token], :access_secret => parameters[:access_secret]}
      @@access = {:access_token => EtsyApi.access_token, :access_secret => EtsyApi.access_secret}
    end

    def consumer(api_key, api_secret) # :nodoc:
      path = '/v2/oauth/'
      @consumer ||= OAuth::Consumer.new(api_key, api_secret, {
        :site               => "https://openapi.etsy.com",
        :request_token_path => "#{path}request_token?scope=#{[].join('+')}",
        :access_token_path  => "#{path}access_token"
      })
    end

    def secure_client
      SecureClient.new(:access_token => @token, :access_secret => @secret)
    end

    def basic_client
      BasicClient.new
    end

    def secure?
      !@token.nil? && !@secret.nil?
    end

  end
end
