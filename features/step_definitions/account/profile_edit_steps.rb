Given /^(?:[^\s]* )is on the edit profile page$/ do
  visit(edit_user_registration_url(subdomain: @account.subdomain))
end

When /^(?:[^\s]* )goes to the home page$/ do
  visit(home_url(subdomain: @account.subdomain))
end

When /^(?:[^\s]* )follows "([^"]*)"$/ do |link|
  click_link(link)
end

Then /^(?:[^\s]* )should be redirected to the edit profile page$/ do
  current_url.should == edit_user_registration_url(subdomain: @account.subdomain)
end

When /^(?:|he )submits profile form with(.*) password$/ do |password|
  password.strip!
  if password == "current"
    fill_in "Current password", with: "password"
  elsif password == "new"
    fill_in "Password", with: "foobar"
    fill_in "Current password", with: "password"
  #for without password
  elsif password == "out"
    fill_in "Current password", with: ""
  end
  click_button "Update"
end

Then /^(?:|he )should see that current password can't be blank$/ do
  page.find(:xpath, '//*[contains(concat( " ", @class, " " ), concat( " ", "optional", " " ))]//*[contains(concat( " ", @class, " " ), concat( " ", "help-inline", " " ))]').text.should == "can't be blank"
end

When /^(?:[^\s]* )goes to the user sign in page$/ do
  visit(new_user_session_url)
end

When /^user submits email and(.*) password$/ do |password|
  password.strip!
  fill_in "Email", with: @user[:email]
  fill_in "Password", with: password == "new" ? "foobar" : "password"
  click_button "Sign in"
end
