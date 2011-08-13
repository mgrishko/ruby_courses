class Notification < ActionMailer::Base

  default :from => "server.ror.account@gmail.com",
          :bcc => 'mrostotski@gmail.com'
#   if Rails.env.production?
#  default :from => "server.ror.account@gmail.com", :bcc => 'pshegai@gmail.com' if Rails.env.development?

  def decline_invitation_request_email(ir)
    @ir = ir
    mail  :to=>@ir.email,
          :subject=>"Sorry, your invitation request was declined."
  end

  def accept_invitation_request_email(user)
    @user = user
    @url = root_url
    mail  :to=>@user.email,
          :subject=>"Welcome to Getmasterdata."
  end

  def password_reset_instructions(user)
    @url = edit_password_reset_url(user.perishable_token)
    mail  :to => user.email,
          :bcc => nil,
          :subject => I18n.t(:application_name) + ': ' + I18n.t(:password_reset_instructions)
  end

end
