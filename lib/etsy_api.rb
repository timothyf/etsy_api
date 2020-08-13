require "etsy_api/version"
require 'etsy_api/request'
require 'etsy_api/response'
require 'oauth'
require 'json'


module EtsyApi
  class Error < StandardError; end

  class << self
    attr_accessor :api_key
    attr_accessor :access_token
    attr_accessor :access_secret
    attr_accessor :api_secret
  end

  # Make Etsy.api_key and Etsy.api_secret global but also local to threads
  #
  # def self.api_key
  #   Thread.current[:etsy_api_key] || @api_key
  # end

end
