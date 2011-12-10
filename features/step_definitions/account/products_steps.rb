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
  submit_new_product_form(table.raw.flatten)
end

When /^he submits a new product form(?: with (?!following)(.*))?$/ do |custom|
  fields = ["Name", "Manufacturer", "Brand", "Description"]
  unless custom.blank?
    custom_field = custom.gsub(/^with\s/, "").humanize
    fields << custom_field unless fields.find_index(custom_field)
  end
  submit_new_product_form(fields)
end

When /^he submits form with updated product$/ do
  # Wait 61 minute here to create a comment later then existing one
  Timecop.travel(Time.now + (Settings.events.collapse_timeframe + 1).minutes) do
    fill_in :name, with: "New product name"
    click_button "Update Product"
  end
  Timecop.return
end

When /^he enters a comment to the product$/ do
  @comment = Fabricate.build(:comment, body: "Some super comment")
  fill_in "Comment", with: @comment.body
end

When /^he submits a comment to the product$/ do
  step "he enters a comment to the product"
  click_button "Create Comment"
end

When /^he edits the product tags$/ do
  @tags = ["tag1", "tag2"]
  fill_in "Tags", with: @tags.join(", ")
end

When /^he adds very long tag$/ do
  fill_in "Tags", with: SecureRandom.hex(Settings.tags.maximum_length + 1)
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

When /^he adds a new product$/ do
  steps %Q{
    When he is on the products page
    And he follows "New Product" within sidebar
    And he submits a new product form with following data:
      | Name         |
      | Manufacturer |
      | Brand        |
      | Description  |
    Then he should be on the product page
    And he should see notice message "Product was successfully created."
  }
end

When /^he deletes the product$/ do
  steps %Q{
    When he is on the product page
    And he follows "Delete Product" within sidebar
  }
end

When /^he updates the product$/ do
  Timecop.travel(Time.now + (Settings.events.collapse_timeframe + 1).minutes) do
    steps %Q{
      When he is on the product page
      And he follows "Edit Product" within sidebar
      And he submits form with updated product
      Then he should be on the product page
      And he should see notice message "Product was successfully updated."
    }
  end
  Timecop.return
end

When /^he adds a comment to the product$/ do
  steps %Q{
    And he is on the product page
    When he submits a comment to the product
  }
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

Then /^he should be on the redisplayed edit product page$/ do
  extract_port(current_url).should == edit_product_url(@product, subdomain: @account.subdomain).gsub("/edit", "")
end

Then /^he should(.*) see that product in the products list$/ do |should_not|
  product = @product || Product.first

  within(".content") do
    if should_not.strip == "not"
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

Then /^he should see that comment among other comments$/ do
  comment = @comment || @product.comments.last
  page.find("#comments_list").find("p", text: comment.body)
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

Then /^he should see that tags within sidebar$/ do
  within(".sidebar") do
    page.find("span.label", text: @tags.first)
  end
end

Then /^he should see that tags under product link$/ do
  page.find("span.label", text: @tags.first)
end

Then /^he should(.*) see "([^"]*)" under product link$/ do |should_not, label|
  within("table") do
    if should_not.strip == "not"
      page.should_not have_content(label)
    else
      page.should have_content(label)
    end
  end
end

Then /^he should see that tag (.*)$/ do |message|
  page.find("#product_tags_list").find(:xpath, ".//..").find("span", text: message)
end

def submit_new_product_form(fields)
  attrs = Fabricate.attributes_for(:product, account: nil)

  fields.each do |field|
    attr = field.downcase.gsub(/\s/, '_').to_sym

    case attr
      when :comment
        step "he enters a comment to the product"
      when :tags
         step "he edits the product tags"
      else
        fill_in field, with:  attrs[attr]
    end
  end
  click_button "Create Product"
end