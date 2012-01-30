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

Then /^he should see "([^"]*)" event for "([^"]*)" subdomain$/ do |txt, subdomain|
  page.should have_selector("td.action span", text: txt)
  
  tr_tag = find(:css, "td.action span").find(:xpath, ".//..//..")

  within(tr_tag) do
    page.should have_selector("td.subdomain", text: subdomain)
  end
end
