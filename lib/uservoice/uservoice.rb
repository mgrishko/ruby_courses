require 'cgi'
require 'ezcrypto'
require 'uservoice/token'
require 'uservoice/instance_methods'
require 'uservoice/view_helpers'
require "erb"
module Uservoice

    # Renders javascript to configure uservoice feedback widget. Options
    # can be used to override default settings like forum id.
    # e.g. uservoice_config_javascript(forum_id => 12345)
    # See https://ACCOUNT.uservoice.com/admin2/docs#/widget for options
    # available.
    #
    def uservoice_config_javascript(options={})
      config = uservoice_configuration['uservoice_options'].dup
      config.merge!(options)

      widget_path = uservoice_configuration['widget']['path']
      if config[:sso] && config[:sso][:guid]
        config.merge!(:params => {:sso => Uservoice::Token.new(
          uservoice_configuration['uservoice_options']['key'],
          uservoice_configuration['uservoice_api']['api_key'],
          config.delete(:sso)).to_s})
      end

      <<-EOS
<script type=\"text/javascript\">
  var uvOptions = #{config.to_json};
  (function() {
    var uv = document.createElement('script'); uv.type = 'text/javascript'; uv.async = true;
    uv.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + '#{widget_path}';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(uv, s);
  })();
</script>
      EOS
    end

  # Making helper method available when module
  # gets included into ActionController::Base.
  #
  def self.included(mod)
    mod.send(:helper_method, :uservoice_configuration)
  end

  # Set uservoice configuration file path.
  # Can be overridden.
  #
  def uservoice_configuration_file #:nodoc:
    "#{::Rails.root}/config/uservoice.yml"
  end

  # Returns the uservoice configuration hash.
  # It's been lazy loaded and cached in the controller class.
  #
  def uservoice_configuration
    @@uservoice_configuration ||= begin
      config = ERB.new(IO.read(uservoice_configuration_file)).result
      configuration = YAML::load(config)
      HashWithIndifferentAccess.new(configuration)
    end
  end

  class Token
    attr_reader :data

    # Creates a sign-in token to authenticate user against
    # the uservoice service.
    # See https://ACCOUNT.uservoice.com/admin2/docs#/sso for
    # data properties available.
    #
    def initialize(key, api_key, data)
      data.merge!({:expires => (Time.now + 5 * 60).to_s})

      crypt_key = EzCrypto::Key.with_password(key, api_key)
      encrypted_data = crypt_key.encrypt(data.to_json)

      @data = CGI.escape(Base64.encode64(encrypted_data).gsub(/\n/, ''))
    end

    def to_s #:nodoc:
      @data
    end
  end
end
