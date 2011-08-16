if Rails.env == 'production'
Webforms::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[Exception] ",
    :sender_address => %{"notifier" <server.ror.account@gmail.com>},
    :exception_recipients => %w{pshegai@gmail.com mrostotski@gmail.com}
end

