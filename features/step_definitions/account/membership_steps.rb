Given /^account with memberships$/ do
  @account = Fabricate(:account_with_memberships)
end

Given /^account$/ do
  @account = Fabricate(:account)
end

Given /^account with another admin$/ do
  @account = Fabricate(:account_with_another_admin)
end

When /^he signs in with "(.*)" email and "(.*)" password$/ do |email, password|
  fill_in "Email", with: email
  fill_in "Password", with: password
  click_button "Sign in"
end

When /^he deletes an account user$/ do
  click_button "Delete"
end

Then /^he should not be able to delete the account owner$/ do
  page.should_not have_button('Delete')
end

Then /^he should not be able to edit the account owner role$/ do
  page.should have_link("Edit", :count => 4)
end

Given /^admin user is on the account memberships page$/ do
  steps %Q{
    Given user is on the user sign in page
    When he signs in with \"#{@account.owner.email}\" email and \"password\" password
    Then he should see notice message \"Signed in successfully.\"
  }

  click_link "Users" 
  page.find "h1", text: "Users"
end

Given /^non owner admin user is on the account memberships page$/ do
  @admin = @account.memberships.select{ |m| m.role?(:admin) && m.user != @account.owner }.first.user
  
  steps %Q{
    Given user is on the user sign in page
    When he signs in with \"#{@admin.email}\" email and \"password\" password
    Then he should see notice message \"Signed in successfully.\"
  }

  click_link "Users" 
  page.find "h1", text: "Users"
end

Then /^he should see account users$/ do
  @account.memberships.each do |m|
    page.find "table.grid", text: "#{m.user.first_name} #{m.user.last_name}"
  end
end

Given /^an authenticated account user$/ do
  @user = @account.memberships.select{|m| !m.role?(:admin) }.first.user
  steps %Q{
    Given user is on the user sign in page
    When he signs in with \"#{@user.email}\" email and \"password\" password
    Then he should see notice message \"Signed in successfully.\"
  }
end

Then /^he should not see account users$/ do
  page.has_no_content? "Users"
end

When /^he opens edit user membership page$/ do
  click_link "Edit"
end

When /^changes the user role$/ do
  select 'Viewer', :from => 'Role'
  click_button "Submit"
end

Then /^he should be redirected to home page$/ do
  current_path.should == root_path
end
