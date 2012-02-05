require 'rubygems'
require 'ezcrypto'
require 'json'
require 'cgi'
require 'base64'

module Uservoice
  class Token
    attr_accessor :data
    
    # If you're acme.uservoice.com then this value would be 'acme'
    USERVOICE_SUBDOMAIN = "FILL IN"
    # Get this from your UserVoice General Settings page
    USERVOICE_SSO_KEY = "FILL IN"
    
    def initialize(options = {})
      options.merge!({:expires => (Time.zone.now.utc + 5 * 60).to_s})
      
      key = EzCrypto::Key.with_password USERVOICE_SUBDOMAIN, USERVOICE_SSO_KEY
      encrypted = key.encrypt(options.to_json)
      @data = Base64.encode64(encrypted).gsub(/\n/,'') # Remove line returns where are annoyingly placed every 60 characters
      # If you are not using rails url helpers to add the token to the url then you will also need to url encode it
      # @data = CGI.escape(@data)
    end
    
    def to_s
      @data
    end
  end
end