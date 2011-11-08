Given /^not activated company account$/ do
  @account = Fabricate(:account)
end

When /^admin goes to the accounts page$/ do
  visit(admin_accounts_url)
end

When /^(?:[^\s]* )activates the account$/ do
  click_link("Show")
  click_link("Activate")
end

