class Notification < ActionMailer::Base
  default :from => "server.ror.account@gmail.com"
  def url
    if RAILS_ENV =='development'
      "localhost:3000"
    else
      'test.getmasterdata.com'
    end
  end
  
  def decline_invitation_request_email(ir)
    @ir = ir
    @url = url
    mail(:to=>@ir.email, :subject=>"Sorry, your invitation request was declined.")
  end
  
  def accept_invitation_request_email(user)
    @user = user
    @url = url
    mail(:to=>@user.email, :subject=>"Welcome to Getmasterdata.")
  end
end
