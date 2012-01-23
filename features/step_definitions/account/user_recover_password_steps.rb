def token
  @user.reload.reset_password_token
end

When /^(?:he|user) submits (.*) email$/ do |email|
  valid_email = @user.nil? ? "user@example.com" : @user.email
  fill_in "Email", with: email == "valid" ? valid_email : "invalid@example.com"
  click_button "Send me reset password instructions"
end

Then /^(?:[^\s]*) should be redirected to the change password page$/ do
  extract_port(current_url).should ==
      edit_user_password_url(subdomain: Settings.app_subdomain, reset_password_token: token)
end

Then /^user should be redirected back to the home page$/ do
  extract_port(current_url).should == home_url(subdomain: @account.subdomain)
end

When /^(?:he|user) submits new password and (.*) confirm it$/ do |confirm|
  fill_in "user_password", with: 'foobar'
  fill_in "user_password_confirmation", with: confirm == "valid" ? "foobar" : "invalid_confirm"
  click_button "Change my password"
end

When /^he submits email and new password$/ do
  visit(new_user_session_url(subdomain: @account.subdomain))
  fill_in "Email", with: @user.email
  fill_in "Password", with: 'foobar'
  click_button "Sign in"
end

Then /^he should receive an email with reset password instructions$/ do
  email_address = @user.email
  unread_emails_for(email_address).size.should == 1
  open_last_email
end

Then /^he shouldn't receive an email with reset password instructions$/ do
  email_address = @user.email
  unread_emails_for(email_address).size.should == 0
end

When /^he goes to the password edit page with invalid token$/ do
  visit(edit_user_password_url(subdomain: Settings.app_subdomain,
                               reset_password_token: "invalid_token"))
end

Then /^he should see success sign up notice message$/ do
  message = "Your password was changed successfully. You are now signed in."
  step "he should see notice message \"#{message}\""
end

Then /^he should see password recovery notice message$/ do
  message = "If your e-mail exists on our database, you will receive a password recovery link on your e-mail"
  step "he should see notice message \"#{message}\""
end

Then /^he should see message "([^"]*)"$/ do |message|
  page.find("span.help-inline", text: message)
end
