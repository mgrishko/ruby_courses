Given /^account with memberships$/ do
  @account = Fabricate(:account_with_memberships)
end

When /^he signs in with "(.*)" email and "(.*)" password$/ do |email, password|
  fill_in "Email", with: email
  fill_in "Password", with: password
  click_button "Sign in"
end

Given /^admin user is on the account memberships page$/ do
  steps %Q{
    Given user is on the user sign in page
    When he signs in with \"#{@account.owner.email}\" email and \"password\" password
    Then he should see notice message \"Signed in successfully.\"
  }

  click_link("Users")
  page.find("h1", text: "Users")
end

Then /^he should see account users$/ do
  @account.memberships.each do |m|
    page.find("table.grid", text: "#{m.user.first_name} #{m.user.last_name}")
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
  page.has_no_content?("Users")
end
