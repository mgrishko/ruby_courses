Given /^account with memberships$/ do
  @account = Fabricate(:account_with_memberships)
end

Given /^active account$/ do
  @account = Fabricate(:active_account)
end

Given /^account with another admin$/ do
  @account = Fabricate(:account_with_another_admin)
end

And /^he is on the account memberships page$/ do
  visit(memberships_url(subdomain: @account.subdomain))
end

Given /^he is on the edit his own membership page$/ do
  visit(edit_membership_url(@membership, subdomain: @account.subdomain))
end

When /^he signs in with "(.*)" email and "(.*)" password$/ do |email, password|
  fill_in "Email", with: email
  fill_in "Password", with: password
  click_button "Sign in"
end

When /^he deletes an account user$/ do
  @membership = @account.memberships.select{|m|!m.role?(:admin)}.first
  click_link("Delete")
end

When /^he navigates to the account memberships page$/ do
  within("#account_menu") do
    click_link "Users"
  end
end

When /^he opens edit user membership page$/ do
  click_link "Edit"
end

When /^changes the user role$/ do
  select 'Viewer', :from => 'Role'
  click_button "Update"
end

When /^he tries to visit account memberships page$/ do
  visit(memberships_url(subdomain: @account.subdomain))
end

Then /^he should see account users$/ do
  @account.memberships.each do |m|
    page.find "table.grid", text: "#{m.user.first_name} #{m.user.last_name}"
  end
end

Then /^he should not see account users menu link$/ do
  page.has_no_content? "Users"
end

Then /^he should be redirected to home page$/ do
  current_path.should == root_path
end

Then /^he should not be able to delete the account owner$/ do
  page.should_not have_link('Destroy')
end

Then /^he should not be able to edit the account owner role$/ do
  page.should have_link("Edit", :count => 4)
end
