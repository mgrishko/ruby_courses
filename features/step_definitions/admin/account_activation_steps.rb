Given /^not activated company account$/ do
  owner = Fabricate(:user, email: "user@example.com", password: "password")
  @account = Fabricate(:account, owner: owner)
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

When /^user signs in with valid credentials$/ do
  current_url.should == new_user_session_url(subdomain: @account.subdomain)
  fill_in "Email", with: "user@example.com"
  fill_in "Password", with: "password"
  click_button "Sign in"
end

Then /^an account owner should receive an invitation email$/ do
  email_address = @account.owner.email
  unread_emails_for(email_address).size.should == 1
  open_email(email_address)
end

Then /^he should be on the company account home page$/ do
  current_url.should == home_url(subdomain: @account.subdomain)
end

