Given /^an unauthenticated admin$/ do
  Fabricate(:admin, email: "admin@example.com", password: "password")
  reset_session!
end

Given /^an authenticated admin$/ do
  Fabricate(:admin, email: "admin@example.com", password: "password")

  Given %{admin is on the sign in page}
  When %{admin submits valid email and password}
end

Given /^(?:[^\s]* )is on the sign in page$/ do
  visit(new_admin_session_url)
end

When /^the admin tries to access a restricted page$/ do
  visit(dashboard_path)
end

When /^admin submits (.*) email and(.*) password$/ do |email, password|
  password.strip!

  fill_in "Email", with: email == "valid" ? "admin@example.com" : "invalid@example.com"
  fill_in "Password", with: password.blank? || password == "valid" ? "password" : "invalid"
  click_button "Sign in"
end

# ToDo Adjust to sign out link when it will be present
When /^(?:[^\s]* )signs out$/ do
  reset_session!
end

When /^(?:[^\s]* )returns next time$/ do
  visit(dashboard_url)
end

Then /^he should be redirected to the login page$/ do
  current_url.should == new_admin_session_url
end

Then /^he should be redirected back to the sign in page$/ do
  current_url.should == new_admin_session_url
end

Then /^(?:[^\s]* )should be redirected back to the restricted page$/ do
  current_url.should == dashboard_url
end

Then /^admin should be signed out$/ do
  current_url.should == new_admin_session_url
end
