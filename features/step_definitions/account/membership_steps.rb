Given /^an authenticated account admin$/ do
  @account = Fabricate(:account_with_memberships)
  #user = Fabricate(:user, email: "user@example.com", password: "password")
  #user.accounts << @account
  #@account.owner = user
end

When /^account admin opens "([^"]*)"$/ do |arg1|

end

Then /^account admin should see the list of account members$/ do

end
