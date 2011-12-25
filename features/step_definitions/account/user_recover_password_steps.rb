def token
  @user.reload.reset_password_token
end

When /^(?:he|user) submits (.*) email$/ do |email|
  valid_email = @user.nil? ? "user@example.com" : @user.email
  fill_in "Email", with: email == "valid" ? valid_email : "invalid@example.com"
  click_button "Send me reset password instructions"
end

Then /^(?:[^\s]*) should be redirected to the change password page$/ do
  current_url.should == edit_user_password_url(port: Capybara.server_port, reset_password_token: token, subdomain: @account.subdomain)
end

When /^(?:he|user) submits new password and confirm it$/ do
  fill_in "user_password", with: 'foobar'
  fill_in "user_password_confirmation", with: 'foobar'
  click_button "Change my password"
end

When /^he submits email and new password$/ do
  fill_in "Email", with: @user.email
  fill_in "Password", with: 'foobar'
  click_button "Sign in"
end

Then /^he should receive an email with reset password instructions$/ do
  email_address = @user.email
  unread_emails_for(email_address).size.should == 1
  open_email(email_address)
end

Then /^(.*) should see that current email (.*)$/ do |user, text|
  page.find("##{user}_email").find(:xpath, '..').find("span", text: text)
end

When /^(?:he|user) fill in hidden_field "([^"]*)" with reset_password_token$/ do |field|
  page.execute_script("$('##{field}').val('#{@user.reload.reset_password_token}');")
end

When /^he visit the reset password page$/ do
  visit(edit_user_password_url(port: Capybara.server_port, subdomain: @account.subdomain))
end
