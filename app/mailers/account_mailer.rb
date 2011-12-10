class AccountMailer < ActionMailer::Base
  default from: Settings.send_mail_from

  def activation_email(account)
    set_current_view_context
    @account = AccountDecorator.decorate(account)
    @owner = @account.owner
    @url = home_url(subdomain: @account.subdomain)
    mail( to: @owner.email, subject: "[#{@account.company_name}] Account for #{@account.company_name} has been activated" )
  end
end
