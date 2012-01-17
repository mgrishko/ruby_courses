Given /^account with memberships$/ do
  @account = Fabricate(:account_with_memberships)
end

Given /^account with another admin$/ do
  @account = Fabricate(:account_with_another_admin)
end

Given /^(?:[^\s]* )is on the account memberships page$/ do
  visit(memberships_url(subdomain: @account.subdomain))
end

Given /^he is on the edit his own membership page$/ do
  visit(edit_membership_url(@membership, subdomain: @account.subdomain))
end

Given /^user with an account membership$/ do
  @invited_user = Fabricate(:user)
  Fabricate(:membership, user: @invited_user, account: @account)
end

Given /^he is on the new membership page$/ do
  visit(new_membership_url(subdomain: @account.subdomain))
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
    click_link "All People"
  end
end

When /^admin goes to the account memberships page$/ do
  visit(memberships_path)
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

When /^he submits the account invitation form with:$/ do |table|
  @invited_user = Fabricate.build(:user)
  submit_invitation_form(@invited_user.attributes, table.raw.flatten)
end

When /^admin tries to invite that user$/ do
  submit_invitation_form(@invited_user.attributes, ["First name", "Last name", "Email", "Role", "Invitation note"])
end

When /^he follows membership invitation link$/ do
  visit_in_email(home_url(subdomain: @account.subdomain))
end

When /^admin invites that user$/ do
  @membership = Fabricate.build(:membership, account: @account)
  @membership.user = User.new(@user.attributes)
  @membership.save
end

Then /^he should see account users$/ do
  @account.memberships.each do |m|
    page.find "table.grid", text: "#{m.user.first_name} #{m.user.last_name}"
  end
end

Then /^he should see that user membership$/ do
  page.has_content? @invited_user.full_name
  reset_session!
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

Then /^user should receive an invitation email (.*) password$/ do |with_text|
  email_address = @user.email
  unread_emails_for(email_address).size.should == 1

  if with_text == "with"
    open_email(email_address, :with_text => "Password:")
    @user.password = "password"
    @user.save!
  else
    open_email(email_address)
  end
end

Then /^he should see that email (.*)$/ do |message|
  page.find("#membership_user_attributes_email").find(:xpath, ".//..").find("span", text: message)
end

Then /^he should be on the redisplayed new membership page$/ do
  current_url.should == membership_invitation_url(subdomain: @account.subdomain)
end


def submit_invitation_form(attrs, fields)
  attrs = attrs.with_indifferent_access
  fields.each do |field|
    attr = field.downcase.gsub(/\s/, '_').to_sym

    case attr
      when :role
        select "Editor", from: field
      when :invitation_note
        fill_in field, with: "This is some invitation note"
      else
        fill_in field, with: attrs[attr]
    end
  end
  click_button "Send an invitation"
end
