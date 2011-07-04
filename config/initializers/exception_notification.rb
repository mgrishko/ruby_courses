Webforms::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[Exception] ",
    :sender_address => %{"notifier" <notifier@demo.getmasterdata.com>},
    :exception_recipients => %w{pshegai@gmail.com}

