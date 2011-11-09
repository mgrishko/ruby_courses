Given /^an unauthenticated admin$/ do
  Fabricate(:admin, email: "admin@example.com", password: "password")
  reset_session!
end

Given /^an authenticated admin$/ do
  Fabricate(:admin, email: "admin@example.com", password: "password")

  steps %Q{
    Given admin is on the admin sign in page
    When admin submits valid email and password
  }
end

Given /^(?:[^\s]* )is on the admin sign in page$/ do
  visit(new_admin_session_url)
end

When /^the admin tries to access a restricted page$/ do
  visit(admin_dashboard_url)
end

When /^admin submits (.*) email and(.*) password$/ do |email, password|
  password.strip!

  fill_in "Email", with: email == "valid" ? "admin@example.com" : "invalid@example.com"
  fill_in "Password", with: password.blank? || password == "valid" ? "password" : "invalid"
  click_button "Sign in"
end

# ToDo Adjust to sign out link when it will be present
When /^admin signs out$/ do
  reset_session!
end

When /^admin returns next time$/ do
  visit(admin_dashboard_url)
end

Then /^he should be redirected to the admin sign in page$/ do
  current_url.should == new_admin_session_url
end

Then /^admin should be redirected back to the restricted page$/ do
  current_url.should == admin_dashboard_url
end

Then /^admin should be signed out$/ do
  current_url.should == new_admin_session_url
end
