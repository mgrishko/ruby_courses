Given /^an unauthenticated admin$/ do
  Fabricate(:admin, email: "admin@example.com", password: "password")
  reset_session!
end

When /^the admin tries to access a restricted page$/ do
  visit(dashboard_path)
end

Then /^he should be redirected to the login page$/ do
  current_url.should == new_admin_session_url
end

When /^admin submits valid credentials$/ do
  fill_in "Email", with: "admin@example.com"
  fill_in "Password", with: "password"
  click_button "Sign in"
end

Then /^he should be redirected back to the restricted page$/ do
  current_url.should == dashboard_url
end
