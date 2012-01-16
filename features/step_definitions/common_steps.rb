When /^he follows "([^"]*)" within (.*)$/ do |link, scope|
  within(".#{scope}") do
    click_on(link)
  end
end

When /^he clicks "([^"]*)" within (.*)$/ do |link, scope|
  within(".#{scope}") do
    click_on(link)
  end
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

Then /^he should see field error "([^"]*)"$/ do |message|
  page.find("form span.help-inline", text: message)
end

# Functions

def execute_script(js)
  page.driver.browser.execute_script(js)
  sleep(1)
end

def find_field(locator)
  find(:xpath, XPath::HTML.fillable_field(locator))
end

def find_field_parent(locator)
  find_field(locator).find(:xpath,".//..")
end