Given /^an activated account$/ do
  user = Fabricate(:user, email: "owner@example.com", password: "password")
  @account = user.accounts.create!(Fabricate.attributes_for(:account, user: nil))
  @account.activate!
end

Given /^some other account$/ do
  @other_account = Fabricate(:account, subdomain: "other")
end

Given /^another active account$/ do
  @another_account = Fabricate(:active_account, subdomain: "another")
end
