Given /^an unauthenticated user$/ do
  Fabricate(:user, email: "user@example.com", password: "password")
  reset_session!
end

Given /^an authenticated user$/ do
  @user = Fabricate(:user, email: "user@example.com", password: "password")

  steps %Q{
    Given user is on the user sign in page
    When user submits valid email and password
  }
end

Given /^an authenticated user with (.*) role$/ do |role|
  step "an authenticated user"

  @membership = Fabricate("#{role}_membership".to_sym, account: @account, user: @user)
end

Given /^an authenticated account owner$/ do
  step "an authenticated user"
  @account.owner = @user
end

Given /^(?:[^\s]* )is on the user sign in page$/ do
  visit(new_user_session_url(subdomain: @account.subdomain))
end

When /^the user tries to access a restricted page$/ do
  visit(home_url(subdomain: @account.subdomain))
end

When /^user submits (.*) email and(.*) password$/ do |email, password|
  password.strip!

  fill_in "Email", with: email == "valid" ? "user@example.com" : "invalid@example.com"
  fill_in "Password", with: password.blank? || password == "valid" ? "password" : "invalid"
  click_button "Sign in"
end

When /^user signs out$/ do
  visit(destroy_user_session_url)
end

When /^user returns next time$/ do
  visit(home_url(subdomain: @account.subdomain))
end

Then /^he should be redirected to the user sign in page$/ do
  current_url.should == new_user_session_url(subdomain: @account.subdomain)
end

Then /^user should be redirected back to the restricted page$/ do
  current_url.should == home_url(subdomain: @account.subdomain)
end

Then /^user should be signed out$/ do
  current_url.should == new_user_session_url(subdomain: @account.subdomain)
end
