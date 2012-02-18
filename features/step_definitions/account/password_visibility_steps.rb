Then /^(?:[^\s]* )should(.*) see filled password(.*)$/ do |should, confirm_password|
  if should.strip! == "not"
    page.should have_selector(:xpath, "//input[@type='password' and @name='user[password]']")
    page.should have_selector(:xpath, "//input[@type='password' and
        @name='user[current_password]']") if confirm_password == "and current password"
    page.should have_selector(:xpath, "//input[@type='password' and
        @name='user[password_confirmation]']") if confirm_password == "and password confirmation"
  else
    page.should have_selector(:xpath, "//input[@type='text' and @name='user[password]']")
    page.should have_selector(:xpath, "//input[@type='text' and
        @name='user[current_password]']") if confirm_password == "and current password"
    page.should have_selector(:xpath, "//input[@type='text' and
        @name='user[password_confirmation]']") if confirm_password == "and password confirmation"
  end
end

When /^(?:|he )fill password(.*) with "([^"]*)"$/ do |confirm_password, password|
  password.strip!
  confirm_password.strip!

  fill_in "Password", with: password unless confirm_password == "and password confirmation"
  fill_in "Current password", with: password if confirm_password == "and current password"

  if confirm_password == "and password confirmation"
    fill_in "New password", with: password
    fill_in "Confirm password", with: password
  end
end

Then /^text in password(.*) field should be "([^"]*)"$/ do |confirm_password, password|
  password.strip!
  confirm_password.strip!

  find_field('user_password').value.should == password
  find_field('user_current_password').value.should == password if confirm_password == "and current password"
  find_field('user_password_confirmation').value.should == password if confirm_password == "and password confirmation"
end
