class AccountMailer < ActionMailer::Base
  default from: "#{Settings.project_name} <#{Settings.send_mail_from}>"

  def activation_email(account)
    set_current_view_context
    @account = AccountDecorator.decorate(account)
    @owner = @account.owner
    @url = home_url(subdomain: @account.subdomain)
    mail(to: @owner.email, subject: I18n.t('mail.account.subject',
         subdomain: @account.subdomain.to_s, company_name: @account.company_name.to_s))
  end
end
