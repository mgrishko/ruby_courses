Given /^an unauthenticated user$/ do
  @user = Fabricate(:user, password: "password")
  reset_session!
end

Given /^an authenticated user$/ do
  @user = Fabricate(:user, password: "password")

  steps %Q{
    Given user is on the user sign in page
    When user submits valid email and password
  }
end

Given /^an authenticated user with (.*) role$/ do |role|
  step "an authenticated user"

  @membership = Fabricate("#{role}_membership".to_sym, account: @account, user: @user)
end

#special for account_settings.feature
Given /^an authenticated user with role (.*)$/ do |role|

  @membership = Fabricate("#{role}_membership".to_sym, account: @account)

  visit(new_user_session_url(port: Capybara.server_port, subdomain: @account.subdomain))
  fill_in "Email", with: @membership.user.email
  fill_in "Password", with: @membership.user.password
  click_button "Sign in"
end

Given /^an unauthenticated user with (.*) role$/ do |role|
  @user = Fabricate(:user, password: "password")
  @membership = Fabricate("#{role}_membership".to_sym, account: @account, user: @user)
end

Given /^an authenticated account owner$/ do
  step "an authenticated user"
  @account.owner = @user
end

Given /^(?:[^\s]* )is on the user sign in page$/ do
  visit(new_user_session_path)
end

When /^the user tries to access a restricted page$/ do
  visit(home_url(subdomain: @account.subdomain))
end

When /^(?:he|user) submits (.*) email and(.*) password$/ do |email, password|
  password.strip!

  valid_email = @user.nil? ? "user@example.com" : @user.email
  fill_in "Email", with: email == "valid" ? valid_email : "invalid@example.com"
  fill_in "Password", with: password.blank? || password == "valid" ? "password" : "invalid"
  click_button "Sign in"
end

When /^user signs out$/ do
  visit(destroy_user_session_url)
end

When /^user returns next time$/ do
  visit(home_url(subdomain: @account.subdomain))
end

When /^he navigates to products page$/ do
  visit(products_url(subdomain: @account.subdomain))
end

When /^he logs in as another account user$/ do
  @another_user = @another_account.owner
  steps %Q{
    Then he signs in with "#{@another_user.email}" email and "111111" password
  }
end

When /^user navigates to another account home page$/ do
  visit(root_url(subdomain: @another_account.subdomain))
end

When /^he navigates to account home page$/ do
  visit(root_url(subdomain: @account.subdomain))
end

Then /^he should be redirected back to the products page$/ do
  current_url.should == products_url(subdomain: @account.subdomain)
end

Then /^he should be prompted to login to another account$/ do
  current_url.should == new_user_session_url(subdomain: @another_account.subdomain)
end

Then /^he should be prompted to login to account$/ do
  current_url.should == new_user_session_url(subdomain: @account.subdomain)
end

Then /^he should be redirected to the user sign in page$/ do
  extract_port(current_url).should == new_user_session_url(subdomain: @account.subdomain)
end

Then /^user should be redirected back to the restricted page$/ do
  current_url.should == home_url(subdomain: @account.subdomain)
end

Then /^user should be signed out$/ do
  current_url.should == new_user_session_url(subdomain: @account.subdomain)
end

Then /^he should be on the global sign in page$/ do
  extract_port(current_url).should == new_user_session_url(subdomain: Settings.app_subdomain)
end