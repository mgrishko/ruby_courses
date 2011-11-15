Given /^an authenticated user with (.*) role$/ do |role|
  step "an authenticated user"

  Fabricate("#{role}_membership".to_sym, account: @account, user: @user)
end

Given /^he is on the products page$/ do
  visit(products_url(subdomain: @account.subdomain))
end

When /^he follows "([^"]*)" within sidebar$/ do |link|
  within(".sidebar") do
    click_on(link)
  end
end

When /^he submits a new product form with following data:$/ do |table|
  attrs = Fabricate.attributes_for(:product, account: nil)

  table.raw.flatten.each do |field|
    attr = field.downcase.gsub(/\s/, '_').to_sym
    fill_in field, with: attrs[attr]
  end
  click_button "Create Product"
end

When /^he goes to the new product page$/ do
  visit(new_product_url(subdomain: @account.subdomain))
end

Then /^he should be on the product page$/ do
  product = Product.first
  current_url.should == product_url(product, subdomain: @account.subdomain)
end

Then /^he should not see "([^"]*)" link within sidebar$/ do |link|
  within(".sidebar") do
    page.should_not have_link(link)
  end
end


