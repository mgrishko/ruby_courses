When /^he adds a new product$/ do
  steps %Q{
    When he is on the products page
    And he follows "New Product" within sidebar
    And he submits a new product form with following data:
      | Name        |
      | Description |
    Then he should be on the product page
    And he should see notice message "Product was successfully created."
  }
end

When /^he goes to home page$/ do
  visit(home_url(subdomain: @account.subdomain))
end

Then /^he should see "([^"]*)" event$/ do |txt|
  page.find("td", text: txt)
end

When /^he deletes the product$/ do
  steps %Q{
    When he is on the product page
    And he follows "Delete Product" within sidebar
  }
end

When /^he updates the product$/ do
  steps %Q{
    When he is on the product page
    And he follows "Edit Product" within sidebar
    And he submits form with updated product
    Then he should be on the product page
    And he should see notice message "Product was successfully updated."
  }
end

Then /^he should see "([^"]*)" comment on the product page$/ do |txt|
  page.find("p", text: txt)
end

Then /^he cannot delete this comment$/ do
  within("div.links") do
    page.should_not have_link('Delete')
  end
end