When /^he follows Dashboard link$/ do
  click_link("Dashboard")
end

Then /^he should see "([^"]*)" event$/ do |txt|
  page.should have_selector("span", text: txt)
end

Then /^he should see new product event$/ do
  product = @account.products.first
  page.should have_selector("span", text: "New")
  page.should have_selector("td", text: product.functional_name)
end

Then /^he deletes the comment$/ do
  steps "When he is on the product page"

  within("div.links") do
    click_link("Delete")
  end
end

Then /^he should see "([^"]*)" comment on the product page$/ do |txt|
  page.find("p", text: txt)
end

Then /^he cannot delete this comment$/ do
  within("div.comment") do
    page.should_not have_link('Delete')
  end
end

Then /^he should see events welcome message:$/ do |string|
  find_welcome_message(string)
end

Then /^he should see events welcome message$/ do
  string = "This Dashboard screen will show you the latest activity in your account.
            But before we can show you activity, you'll need to create the first product."
  find_welcome_message(string)
end

Then /^he should not see events welcome box$/ do
  page.should_not have_selector(".welcome_box")
end

def find_welcome_message(string)
  string = string.split(/\s/).reject(&:blank?).join(" ")
  within(".welcome_box") do
    page.should have_content(string)
  end
end