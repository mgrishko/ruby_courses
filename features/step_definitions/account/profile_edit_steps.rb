Given /^(?:[^\s]* )is on the user edit page$/ do
  visit(edit_user_registration_url(subdomain: @account.subdomain))
end

When /^(?:[^\s]* )follow "([^"]*)"$/ do |link|
  click_link(link)
end

Then /^(?:[^\s]* )should be redirected to the edit profile page$/ do
  current_url.should == edit_user_registration_url(subdomain: @account.subdomain)
end

When /^(?:[^\s]* )goes to the home page$/ do
  visit(home_url(subdomain: @account.subdomain))
end

When /^(?:[^\s]* )goes to the user sign in page$/ do
  visit(new_user_session_url(subdomain: @account.subdomain))
end

When /^(?:|he )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, with: value)
end

When /^(?:|he )submits profile form (.*) current password and (.*) password$/ do |current_password, password|
  current_password.strip!
  password.strip!

  fill_in "First name", with: "John"
  fill_in "Last name", with: "Smith"
  fill_in "Email", with: "email@mail.com"
  select "Moscow", from: "Time zone"
  fill_in "Password", with: password == "with" ? "foobar" : ""
  fill_in "Current password", with: current_password == "current" ? "password" : ""
  click_button "Update"
end
