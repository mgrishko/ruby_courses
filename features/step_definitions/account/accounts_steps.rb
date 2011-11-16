Given /^an activated account$/ do
  user = Fabricate(:user, email: "owner@example.com", password: "password")
  @account = user.accounts.create!(Fabricate.attributes_for(:account, user: nil))
  @account.activate!
end

Given /^some other account$/ do
  @other_account = Fabricate(:account, subdomain: "other")
end