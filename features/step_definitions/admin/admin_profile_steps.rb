Then /^he should see next links:$/ do |table|
  table.hashes.each do |key, link|
    page.should have_link("#{link}")
  end
end

Then /^(?:[^\s]* )should be redirected to the admin profile page$/ do
  current_url.should == edit_admin_url(@admin, subdomain: Settings.app_subdomain)
end

Given /^(?:[^\s]* )is on the admin profile page$/ do
  visit(edit_admin_url(@admin, subdomain: Settings.app_subdomain))
end

When /^admin submits email and(.*) password$/ do |password|
  password.strip!
  fill_in "Email", with: @admin[:email]
  fill_in "Password", with: password == "new" ? "foobar" : "password"
  click_button "Sign in"
end
