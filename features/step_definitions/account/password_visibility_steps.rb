Then /^(?:[^\s]* )should(.*) see filled password(.*)$/ do |should, current_password|
  if should.strip! == "not"
    page.should have_selector(:xpath, "//input[@type='password' and @name='user[password]']")
    page.should have_selector(:xpath, "//input[@type='password' and @name='user[current_password]']") if !current_password.empty?
  else
    page.should have_selector(:xpath, "//input[@type='text' and @name='user[password]']")
    page.should have_selector(:xpath, "//input[@type='text' and @name='user[current_password]']") if !current_password.empty?
  end
end

When /^(?:|he )fill password(.*) with "([^"]*)"$/ do |current_password, password|
  password.strip!
  fill_in "Password", with: password
  fill_in "Current password", with: password if !current_password.empty?
end

Then /^text in password(.*) field should be "([^"]*)"$/ do |current_password, password|
  password.strip!
  find_field('user_password').value.should == password
  find_field('user_current_password').value.should == password if !current_password.empty?
end
