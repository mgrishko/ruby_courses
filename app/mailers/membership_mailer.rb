class MembershipMailer < ActionMailer::Base
  default from: Settings.send_mail_from

  def invitation_email(membership)
    set_current_view_context
    membership = MembershipDecorator.decorate(membership)
    @invited_by = membership.invited_by
    @user = membership.user
    @account = membership.account
    @url = home_url(subdomain: @account.subdomain)
    @invitation_note = membership.invitation_note

    mail( to: @user.email, subject: "[#{@account.company_name}] Welcome to #{Settings.project_name}" )
  end
end
