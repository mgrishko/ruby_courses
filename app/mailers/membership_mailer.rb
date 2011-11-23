class MembershipMailer < ActionMailer::Base
  default from: Settings.send_mail_from

  # ToDo Refactor to user AccountDraper
  def invitation_email(membership)
    @invited_by = membership.invited_by
    @user = membership.user
    @account = membership.account
    @url = home_url(subdomain: @account.subdomain)
    @invitation_note = membership.invitation_note

    mail( to: @user.email, subject: "Welcome to #{Settings.project_name}" )
  end
end
