class AccountMailer < ActionMailer::Base
  default from: "system@goodsmaster.com"

  # ToDo Refactor to user AccountDraper
  def activation_email(account)
    @owner = account.owner
    @url = home_url(subdomain: account.subdomain)
    mail( to: @owner.email, subject: "Account for #{account.company_name} has been activated" )
  end
end
