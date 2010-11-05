module Terbium
  module Rack
    class TranslationsOverlay

      def initialize(app)
        @app = app
      end

      def call(env)
        request = ::Rack::Request.new(env)
        if locale = request.path_info.scan(/_(#{I18n.available_locales.join('|')})\/?$/).flatten.first
          path_was = request.path_info
          request.path_info = request.path_info.sub(/_#{locale}\/?$/, '')
          request.path_info += '/' if path_was.end_with?('/')
          env["REQUEST_PATH"] = env["REQUEST_PATH"].sub(/#{path_was}/, request.path_info) if env["REQUEST_PATH"]
          env["REQUEST_URI"] = env["REQUEST_URI"].sub(/#{path_was}/, request.path_info) if env["REQUEST_URI"]
          request.params[:translation] = locale
        end
        @app.call(env)
      end

    end
  end
end

