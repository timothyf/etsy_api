require 'net/http'
require 'json'
require 'oauth'
require 'uri'

require 'etsy_api/request'
require 'etsy_api/response'

#require 'etsy_api/basic_client'
require 'etsy_api/secure_client'
require 'etsy_api/verification_request'

require 'etsy_api/model'
require 'etsy_api/user'

require "etsy_api/version"
require 'etsy_api/element'
require 'etsy_api/shop'
require 'etsy_api/listing'


module EtsyApi
  class Error < StandardError; end


  class << self
    attr_accessor :api_key
    attr_accessor :access_token
    attr_accessor :access_secret
    attr_accessor :api_secret
    attr_writer :callback_url
    attr_writer :permission_scopes
  end

  SANDBOX_HOST = 'sandbox.openapi.etsy.com'
  PRODUCTION_HOST = 'openapi.etsy.com'

  # def self.api_key
  #   Thread.current[:etsy_api_key] || @api_key
  # end
  #
  # def self.api_key=(key)
  #   @api_key ||= key
  #   Thread.current[:etsy_api_key] = key
  # end

  # def self.api_secret
  #   Thread.current[:etsy_api_secret] || @api_secret
  # end
  #
  # def self.api_secret=(secret)
  #   @api_secret ||= secret
  #   Thread.current[:etsy_api_secret] = secret
  # end

  def self.request_token
    clear_for_new_authorization
    verification_request.request_token
  end

  def self.permission_scopes
    @permission_scopes || []
  end

  def self.callback_url
    @callback_url || 'oob'
  end

  def self.host # :nodoc:
    @host || PRODUCTION_HOST
  end

  def self.protocol
    @protocol || "https"
  end

  def self.environment
    @environment || :production
  end

  def self.environment=(environment)
    unless [:sandbox, :production].include?(environment)
      raise(ArgumentError, "environment must be set to either :sandbox or :production")
    end
    @environment = environment
    @host = (environment == :sandbox) ? SANDBOX_HOST : PRODUCTION_HOST
  end

  def self.protocol=(protocol)
    unless ["http", "https"].include?(protocol.to_s)
      raise(ArgumentError, "protocol must be set to either 'http' or 'https'")
    end
    @protocol = protocol.to_s
  end

  def self.user(username)
    EtsyApi::User.find(username, {:access_secret=>EtsyApi.access_secret,
                                  :access_token=>EtsyApi.access_token,
                                  :api_key=>EtsyApi.api_key})
  end

  def self.myself(token, secret, options = {})
    User.myself(token, secret, options)
  end

  def self.verification_url
    verification_request.url
  end

  def self.single_user(access_token, access_secret)
    @credentials = {
      :access_token => access_token,
      :access_secret => access_secret
    }
    nil
  end

  def self.get_access_token(request_token, request_secret, verifier)
    @access_token = begin
      client = EtsyApi::SecureClient.new({
        :request_token  => request_token,
        :request_secret => request_secret,
        :verifier       => verifier
      })
      client.client
    end
  end

  def self.credentials
    @credentials || {}
  end

  # Make Etsy.api_key and Etsy.api_secret global but also local to threads
  #
  # def self.api_key
  #   Thread.current[:etsy_api_key] || @api_key
  # end

  private

  def self.verification_request
    @verification_request ||= VerificationRequest.new
  end

  def self.clear_for_new_authorization
    @verification_request = nil
  end

end
