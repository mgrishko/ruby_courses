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
    @product.update_attributes functional_name: SecureRandom.hex(10)
  end
end

Given /^he should be on the product version (\d+) page$/ do |count|
  extract_port(current_url).should == product_version_url(@product, version: count, subdomain: @account.subdomain)
end

Given /^another product with ([A-Za-z_0-9]+) "([^"]*)"$/ do |field, value|
  if field == "tags"
    @another_product = Fabricate(:product, :account => @account)
    value.split(",").each { |tag| Fabricate(:tag, taggable: @another_product, name: tag.strip) }
  else
    @another_product = Fabricate(:product, field.to_sym => value, :account => @account)
  end
end

Given /^an authenticated user with editor role on edit product page$/ do
  steps %Q{
    Given an authenticated user with editor role
    And he is on the product page
    When he follows "Edit Product" within sidebar
  }
end

When /^he enters "([^"]*)" into "([^"]*)" field and selects "([^"]*)" autocomplete option$/ do |text, locator, option|
  field = find(:xpath, XPath::HTML.fillable_field(locator))
  field_id = field[:id]
  
  page.driver.browser.execute_script "$('input##{field_id}').trigger('focus')"
  page.fill_in(locator, with: text)
  page.driver.browser.execute_script "$('input##{field_id}').trigger('keydown')"
  sleep(3)
  page.driver.browser.execute_script "$('.ui-menu-item a').trigger('mouseenter').trigger('click')"
  sleep(3)
end

When /^he enters "([^"]*)" into Tags field and selects "([^"]*)" multi autocomplete option$/ do |text, option|
  # Enter text into text field
  page.driver.browser.execute_script "$('#token-input-product_tags_list').val('#{text}')"
  # Trigger keydown to open the dropdown
  page.driver.browser.execute_script "$('#token-input-product_tags_list').trigger($.Event('keydown', { keyCode: 71 }))"
  sleep(3)
  # Select the option in the dropdown
  page.driver.browser.execute_script("
    $('.token-input-dropdown-goodsmaster ul li').each(function(index) {
      if ($(this).text() == '#{option}') {
        var e = $.Event('mousedown', { target: $(this).children().get(0) });
        $('.token-input-dropdown-goodsmaster ul').trigger(e);
      }
    });
  ")
  sleep(3)
end

Given /^the product has tags "([^"]*)"$/ do |tags|
  tags.split(",").each { |tag| Fabricate(:tag, taggable: @product, name: tag.strip) }
end

When /^he deletes tags$/ do
  sleep(3)
  page.driver.browser.execute_script "$('.token-input-token-goodsmaster span').click()"
end

When /^he submits the product form$/ do
  click_button "Update Product"
end

When /^he follows product link$/ do
  click_link(@product.name)
end

When /^he submits a new product form with following data:$/ do |table|
  submit_new_product_form(table.raw.flatten)
end

When /^he submits a new product form(?: with (?!following)(.*))?$/ do |custom|
  fields = [
      "Functional name",
      "Variant",
      "Brand",
      "Sub brand",
      "Manufacturer",
      "Country of origin",
      "Short description",
      "Description",
      "Gtin"
  ]
  unless custom.blank?
    custom_field = custom.gsub(/^with\s/, "").humanize
    fields << custom_field unless fields.find_index(custom_field)
  end
  submit_new_product_form(fields)
end

When /^he submits form with updated product$/ do
  # Wait 61 minute here to create a comment later then existing one
  Timecop.travel(Time.now + (Settings.events.collapse_timeframe + 1).minutes) do
    fill_in :functional_name, with: "New product name"
    click_button "Update Product"
  end
  Timecop.return
end

When /^he enters a comment to the product$/ do
  @comment = Fabricate.build(:comment, body: "Some super comment")
  fill_in "Comment", with: @comment.body
end

When /^he enters the following measurements:$/ do |table|
  fields = table.raw.flatten

  fields.each do |field|
    attr = /^.*unit$/.match(field) ? :select : :input
    value = attr == :select ? "ml" : "100"
    case attr
      when :select
        select value, from: field
      else
        fill_in field, with: value
    end
  end
end

When /^he enters the following product codes:$/ do |table|
  fields = table.raw.flatten

  fields.each do |field|
    fill_in field, with: "0001"
  end
end

When /^he submits a (.*)comment to the product$/ do |adj|
  step "he enters a comment to the product" unless adj.present?
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
    And he submits a new product form
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

When /^he deletes the product photo$/ do
  steps %Q{
    And he is on the edit product page
    When he clicks "Delete photo" within sidebar
    Then he should see notice message "Photo was successfully deleted"
  }
end

When /^he deletes that comment$/ do
  within("tr.comment") do
    click_link "Delete"
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

Then /^he should(.*) see that comment on the top of comments$/ do |should_not|
  comment = @comment || @product.comments.last

  within("#comments_list") do
    if should_not.strip == "not"
      page.should_not have_content(comment.body)
    else
      page.first(".comment").find("p", text: comment.body)
    end
  end
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

Then /^he should see that comment body (.*)$/ do |text|
  page.find("#comment_body").find(:xpath, '..').find("span", text: text)
end

Then /^he should see validation error for "([^"]*)" untill he enters "([^"]*)"$/ do |locator, value|
  field = find(:xpath, XPath::HTML.fillable_field(locator))
  within("form#new_product") { page.should_not have_content("can't be blank") }
  page.driver.browser.execute_script("$('##{field[:id]}').blur()")

  sleep(2)

  within("form#new_product") { page.should have_content("can't be blank") }
  fill_in(locator, with: value)
  page.driver.browser.execute_script("$('##{field[:id]}').blur()")

  sleep(2)
  
  within("form#new_product") { page.should_not have_content("can't be blank") }
end

Then /^he should not see product tags "([^"]*)"$/ do |tags|
  tags.split(",").each do |tag| 
    within(:css, "ul.product-tags") { page.should_not have_content(tag) }
  end
end

Then /^he should see product ([A-Za-z_0-9]+) "([^"]*)"$/ do |field, value|
  if field == "tags"
    within(:css, "ul.product-#{field}") { page.should have_content(value) }
  else
    within(:css, "p.product-#{field}") { page.should have_content(value) }
  end
end

# Functions

def submit_new_product_form(fields)
  attrs = Fabricate.attributes_for(:product, account: nil)

  fields.each do |field|
    attr = field.downcase.gsub(/\s/, '_').to_sym

    case attr
      when :country_of_origin
        select Carmen.country_name(attrs[attr]), from: field

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