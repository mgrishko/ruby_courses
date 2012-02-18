require "uservoice/config"

module Uservoice
  module ViewHelpers
    include Uservoice::Config

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
  end
end