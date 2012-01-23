When /^he opens the account page$/ do
  visit(admin_accounts_url)
  click_link("Show")
end

When /^logs in as the account owner$/ do
  steps "And he follows \"Login as account owner\" within content"
end

When /^admin goes to the events page$/ do
  visit(admin_events_url)
end