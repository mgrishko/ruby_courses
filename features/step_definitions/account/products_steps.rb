Given /^he is on the account home page$/ do
  visit(home_url(subdomain: @account.subdomain))
end

Given /^he is on the products page$/ do
  visit(products_url(subdomain: @account.subdomain))
end

Given /^that account has a (.*)product(.*)$/ do |prefix, suffix|
  fabricator = "#{prefix}product#{suffix}".gsub(/\s/, "_").to_sym
  @product = Fabricate(fabricator, account: @account)
end

Given /^that other account has a product$/ do
  @product = Fabricate(:product, account: @other_account)
end

Given /^he is on the product page$/ do
  visit(product_path(@product))
end

Given /^he is on the edit product page$/ do
  visit(edit_product_path(@product))
end

Given /^he is on the new product page$/ do
  visit(new_product_path(subdomain: @account.subdomain))
  @product = nil
end

Given /^the product has (\d+) versions$/ do |count|
  (2..count.to_i).each do
    @product.update_attributes name: SecureRandom.hex(10)
  end
end

Given /^he should be on the product version (\d+) page$/ do |count|
  extract_port(current_url).should == product_version_url(@product, version: count, subdomain: @account.subdomain)
end

When /^he follows product link$/ do
  click_link(@product.name)
end

When /^he submits a new product form with following data:$/ do |table|
  attrs = Fabricate.attributes_for(:product, account: nil)

  table.raw.flatten.each do |field|
    attr = field.downcase.gsub(/\s/, '_').to_sym
    if attr == :comment
      step "he enters a comment to the product"
    else
      fill_in field, with:  attrs[attr]
    end
  end
  click_button "Create Product"
end

When /^he submits form with updated product$/ do
  sleep(1) # Sleep here in order to create a comment 1 second later then existing one

  fill_in :name, with: "New product name"
  click_button "Update Product"
end

When /^he enters a comment to the product$/ do
  @comment = Fabricate.build(:comment, body: "Some super comment")
  fill_in "Comment", with: @comment.body
end

When /^he submits a comment to the product$/ do
  step "he enters a comment to the product"
  click_button "Create Comment"
end

When /^he edits product tags$/ do
  @tags = ["tag1", "tag2"]
  fill_in "Tags", with: @tags.join(" ")
end

When /^he sets product visibility to (.*)$/ do |visibility|
  select visibility.humanize, from: "Visibility"
end

When /^he changes product visibility to "([^"]*)"$/ do |visibility|
  step "he sets product visibility to #{visibility}"
end

When /^he goes to the new product page$/ do
  visit(new_product_url(subdomain: @account.subdomain))
end

When /^he goes to the update product page$/ do
  visit(edit_product_url(@product, subdomain: @account.subdomain))
end

When /^he goes to the products page$/ do
  visit(products_url(subdomain: @account.subdomain))
end

When /^he attaches the product photo$/ do
  within("#new_photo") do
    attach_file('photo_image', File.join(Rails.root, '/spec/fabricators/image.jpg'))
  end
end

Then /^he should be on the product page$/ do
  product = @product || Product.last
  extract_port(current_url).should == product_url(product, subdomain: @account.subdomain)
end

Then /^he should(.*) see "([^"]*)" text within sidebar$/ do |should, text|
  within(".sidebar") do
    if should.strip == "not"
      page.should_not have_content(text)
    else
      page.should have_content(text)
    end
  end
end

Then /^he should be on the products page$/ do
  extract_port(current_url).should == products_url(subdomain: @account.subdomain)
end

Then /^he should be on the edit product page$/ do
  extract_port(current_url).should == edit_product_url(@product, subdomain: @account.subdomain)
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

Then /^he should see that comment on the top of comments$/ do
  comment = @comment || @product.comments.last
  page.find("#comments_list").first(".comment").find("p", text: comment.body)
end

Then /^he should see product comments$/ do
  page.find("#comments_list .comment p", text: @product.comments.first.body)
end

Then /^he should not see new comment form$/ do
  page.should have_no_selector("form#new_comment")
end

Then /^he should see missing photo within sidebar$/ do
  # Actually we should check here that missing photo is present but it is not designed for now.
  @product.reload.photos.should be_empty
end

Then /^he should see that tags under product name$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^he should see that tags under product link$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^he should(.*) see "([^"]*)" under product name$/ do |should_not, label|
  pending # express the regexp above with the code you wish you had
end

Then /^he should see "([^"]*)" under product link$/ do |label|
  pending # express the regexp above with the code you wish you had
end