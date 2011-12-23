Given /^(?:[^\s]* )is on the user profile page$/ do
  visit(edit_user_registration_url(subdomain: @account.subdomain))
end

When /^(?:[^\s]* )goes to the home page$/ do
  visit(home_url(subdomain: @account.subdomain))
end

Then /^(?:[^\s]* )should be redirected to the user profile page$/ do
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

Then /^(.*) should see that current password (.*)$/ do |user, text|
  page.find("##{user}_current_password").find(:xpath, '..').find("span", text: text)
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