class MembershipMailer < BaseMailer
  default from: "#{Settings.project_name} <#{Settings.send_mail_from}>"

  def invitation_email(membership)
    set_current_view_context
    @membership = MembershipDecorator.decorate(membership)
    @invited_by = membership.invited_by
    @user = membership.user
    @account = membership.account
    @url = home_url(subdomain: @account.subdomain)
    @invitation_note = membership.invitation_note
    mail( to: @user.email, subject: I18n.t('mail.membership.subject',
                                           company_name: @account.company_name.to_s,
                                           project_name: Settings.project_name.to_s ))
  end
end
