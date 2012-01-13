class BaseMailer < ActionMailer::Base
  default from: "#{Settings.project_name} <#{Settings.send_mail_from}>"
end
