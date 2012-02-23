if Rails.env == 'production'
Webforms::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[Exception] ",
    :sender_address => %{"notifier" <server.ror.account@gmail.com>},
    :exception_recipients => %w{mrostotski@gmail.com mikhailaleksandrovi4@gmail.com voldyjeengle@gmail.com}
end

