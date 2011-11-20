Given /^he is on the account home page$/ do
  visit(home_url(subdomain: @account.subdomain))
end

Given /^he is on the products page$/ do
  visit(products_url(subdomain: @account.subdomain))
end

Given /^that account has a product$/ do
  @product = Fabricate(:product, account: @account)
end

And /^that other account has a product$/ do
  @product = Fabricate(:product, account: @other_account)
end

Given /^he is on the product page$/ do
  visit(product_url(@product, subdomain: @account.subdomain))
end

When /^he follows "([^"]*)" within sidebar$/ do |link|
  within(".sidebar") do
    click_on(link)
  end
end

When /^he follows product link$/ do
  click_link(@product.name)
end

When /^he submits a new product form with following data:$/ do |table|
  attrs = Fabricate.attributes_for(:product, account: nil)

  table.raw.flatten.each do |field|
    attr = field.downcase.gsub(/\s/, '_').to_sym
    fill_in field, with: attrs[attr]
  end
  click_button "Create Product"
end

When /^he submits form with updated product$/ do
  fill_in :name, with: "New product name"
  click_button "Update Product"
end

When /^he goes to the new product page$/ do
  visit(new_product_url(subdomain: @account.subdomain))
end

When /^he goes to the update product page$/ do
  visit(edit_product_url(@product, subdomain: @account.subdomain))
end

When /^he goes to the products list$/ do
  visit(products_url(subdomain: @account.subdomain))
end

When /^he follows "([^"]*)" within header$/ do |link|
  within(".topbar") do
    click_link(link)
  end
end

Then /^he should be on the product page$/ do
  product = @product || Product.first
  current_url.should == product_url(product, subdomain: @account.subdomain)
end

Then /^he should(.*) see "([^"]*)" link within sidebar$/ do |should, link|
  within(".sidebar") do
    if should.strip == "not"
      page.should_not have_link(link)
    else
      page.should have_link(link)
    end
  end
end

Then /^he should be on the products page$/ do
  current_url.should == products_url(subdomain: @account.subdomain)
end

Then /^he should(.*) see that product in the products list$/ do |should|
  product = @product || Product.first

  within(".content") do
    if should.strip == "not"
      page.should_not have_content(product.name)
    else
      page.should have_content(product.name)
    end
  end
end