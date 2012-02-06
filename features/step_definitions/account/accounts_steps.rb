Given /^an activated account$/ do
  @user = Fabricate(:user, email: "owner@example.com", password: "password")
  @account = @user.accounts.create!(Fabricate.attributes_for(:account, user: nil, subdomain: "company"))
  @account.activate!

  set_current_subdomain(@account.subdomain)
end

Given /^some other account$/ do
  @other_account = Fabricate(:account, subdomain: "othercompany")

  set_current_subdomain(@account.subdomain)
end

Given /^another active account$/ do
  @another_account = Fabricate(:active_account, subdomain: "othercompany")

  set_current_subdomain(@account.subdomain)
end

When /^(?:[^\s]* )goes to the(?: account)? home page$/ do
  visit home_path
end
