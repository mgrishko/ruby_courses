Then /^he should see next links:$/ do |table|
  table.hashes.each do |key, link|
    page.should have_link("#{link}")
  end
end

Then /^(?:[^\s]* )should be redirected to the admin profile page$/ do
  current_url.should == edit_admin_registration_url(subdomain: Settings.app_subdomain)
end

When /^(?:|he )submits admin profile form with(.*) password$/ do |password|
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

Given /^(?:[^\s]* )is on the admin profile page$/ do
  visit(edit_admin_registration_url(subdomain: Settings.app_subdomain))
end

Then /^(?:|he )should see that admin current password can't be blank$/ do
  page.find("#admin_current_password").find(:xpath, '..').find("span", text: "can't be blank")
end

When /^admin submits email and(.*) password$/ do |password|
  password.strip!
  fill_in "Email", with: @admin[:email]
  fill_in "Password", with: password == "new" ? "foobar" : "password"
  click_button "Sign in"
end
