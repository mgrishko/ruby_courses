class AccountMailer < ActionMailer::Base
  default from: Settings.send_mail_from

  # ToDo Refactor to user AccountDraper
  def activation_email(account)
    @owner = account.owner
    @account = account
    @url = home_url(subdomain: account.subdomain)
    mail( to: @owner.email, subject: "Account for #{account.company_name} has been activated" )
  end
end
