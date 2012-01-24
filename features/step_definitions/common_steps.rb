When /^he follows "([^"]*)" within (.*)$/ do |link, scope|
  within(".#{scope}") { click_on(link) }
end

When /^he clicks "([^"]*)" within (.*)$/ do |link, scope|
  within(".#{scope}") { click_on(link) }
end

When /^he enters "([^"]*)" into "([^"]*)" field and selects "([^"]*)" autocomplete option$/ do |text, locator, option|
  field = find_field(locator)

  execute_script "$('input##{field[:id]}').trigger('focus')"
  page.fill_in(locator, with: text)
  execute_script "$('input##{field[:id]}').trigger('keydown')"
  execute_script "$('.ui-menu-item a').trigger('mouseenter').trigger('click')"
end

Then /^he should see "([^"]*)" within "([^"]*)"$/ do |content, scope|
  within(".#{scope}") do
    page.should have_content(content)
  end
end

Then /^he should not see tags$/ do
  page.should_not have_selector(".token-input-token-goodsmaster")
end

Then /^he should(.*) see "([^"]*)" link within (.*)$/ do |should, link, context|
  selector = page.has_selector?(context) ? context : ".#{context}"

  should_have = !(should.strip == "not")

  if should_have || (!should_have && page.has_selector?(selector))
    within(selector) do
      if should_have
        page.should have_link(link)
      else
        page.should_not have_link(link)
      end
    end
  end
end

Then /^he should(.*) see "([^"]*)" within sidebar$/ do |should, content|
  within(".sidebar") do
    if should.strip == "not"
      page.should_not have_content(content)
    else
      page.should have_content(content)
    end
  end
end

Then /^(?:[^\s]* )should see (.*) message "([^"]*)"$/ do |flash_class, message|
  page.find(".alert-message.#{flash_class} > p", text: message)
end

Then /^(?:[^\s]* )should(.*) see text "([^"]*)"$/ do |should, content|
  if should.strip == "not"
    page.should_not have_content(content)
  else
    page.should have_content(content)
  end
end

Then /^he should see field error "([^"]*)"$/ do |message|
  page.find("form span.help-inline", text: message)
end

Then /^he should(.*) see validation error "([^"]*)" for "([^"]*)" if he fills it with "([^"]*)"$/ do |should, msg, inputs, value|
  should_have_validation_error = !(should.strip == "not")
  input_names = inputs.split(";").collect{ |l| l.strip }
  input_names.each { |name| fill_in(name, with: value) }
  
  wait
  
  input_names.each do |name|
    within(find_field_parent(name)) do
      if should_have_validation_error
        page.should have_content(msg)
      else
        page.should_not have_content(msg)
      end
    end
  end
end

Then /^he should see validation error "([^"]*)" for "([^"]*)" if he fills in "([^"]*)" with "([^"]*)"$/ do |msg, inputs, input, value|
  fill_in(input, with: value)
  
  wait
  
  input_names = inputs.split(";").collect{ |l| l.strip }
  
  input_names.each do |name|
    within(find_field_parent(name)) do
      page.should have_content(msg)
    end
  end
  
  input_names.each { |name| fill_in(name, with: value) }
end

Then /^he should(.*) see validation error for "([^"]*)" if he leaves it empty$/ do |should, locator|
  should_have_validation_error = !(should.strip == "not")
  input_names = locator.split(";").collect{ |l| l.strip }

  input_names.each do |name|
    field = find_field(name)

    if should_have_validation_error
      within(find_field_parent(name)) do
        page.should_not have_content("can't be blank")
      end
      execute_script("$('##{field[:id]}').blur()")

      within(find_field_parent(name)) do
        page.should have_content("can't be blank")
      end
      fill_in(name, with: "something")
    else
      fill_in(name, with: "")
    end
    
    execute_script("$('##{field[:id]}').blur()")
  end

  within("form#new_product") { page.should_not have_content("can't be blank") }
end

Then /^he should(.*) see error in "([^"]*)" for "([^"]*)" if(.*) field empty$/ do
                                                                 |should, form, locator, type|
  should_have_validation_error = !(should.strip == "not")
  text_field = !(type.strip == "select")
  input_names = locator.split(",").collect{ |l| l.strip }

  input_names.each do |name|
    field = find_field(name)

    if should_have_validation_error
      execute_script("$('##{field[:id]}').val('')")
      execute_script("$('##{field[:id]}').keyup()")

      wait

      within(find_field_parent(name)) do
        page.should have_content("can't be blank")
      end

      if text_field
        fill_in(locator, with: locator == "Email" ? "foo@bar.com" : "something")
        execute_script("$('##{field[:id]}').keyup()")
      else
        execute_script("$('##{field[:id]}').val('Moscow')")
        execute_script("$('##{field[:id]}').keyup()")
      end

      wait
    end

    within("form##{form}") do
      page.should_not have_content(
        (locator == "Email" && text_field) ? ( "can't be blank" || "is invalid") : "can't be blank"
      )
    end
  end
end


# Functions

def wait
  sleep(0.1)
end

def execute_script(js)
  page.driver.browser.execute_script(js)
  wait
end

def find_field(locator)
  find(:xpath, XPath::HTML.fillable_field(locator))
end

def find_field_parent(locator)
  find_field(locator).find(:xpath,".//..")
end
