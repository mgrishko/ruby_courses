When /^he follows Dashboard link$/ do
  click_link("Dashboard")
end

Then /^he should see "([^"]*)" event$/ do |txt|
  page.find("td", text: txt)
end

Then /^he deletes the comment$/ do
  steps %Q{
    When he is on the product page
  }
  within("div.links") do
    click_link("Delete")
  end
end

Then /^he should see "([^"]*)" comment on the product page$/ do |txt|
  page.find("p", text: txt)
end

Then /^he cannot delete this comment$/ do
  within("div.links") do
    page.should_not have_link('Delete')
  end
end