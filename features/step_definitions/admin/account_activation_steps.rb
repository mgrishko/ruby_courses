Given /^company representative has a new account$/ do
  @owner = Fabricate(:user, email: "user@example.com", password: "password")
  @account = Fabricate(:account, owner: @owner)
  
  visit new_user_session_url(subdomain: @account.subdomain)
  fill_in "Email", with: @owner.email
  fill_in "Password", with: @owner.password
  click_button "Sign in"
end

When /^admin goes to the accounts page$/ do
  visit(admin_accounts_url)
end

When /^(?:[^\s]* )activates the account$/ do
  click_link("Show")
  click_link("Activate")
end

When /^he follows company account link$/ do
  visit_in_email(home_url(subdomain: @account.subdomain))
end

Then /^an account owner should receive an activation email$/ do
  email_address = @account.owner.email
  unread_emails_for(email_address).size.should == 1
  open_email(email_address)
end

Then /^he should be on the company account home page$/ do
  current_url.should == home_url(subdomain: @account.subdomain)
end

Then /^he should be on the account list page$/ do
  current_url.should == admin_accounts_url(subdomain: Settings.app_subdomain)
end
