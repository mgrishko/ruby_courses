When /^(?:|I )select "([^""]*)" from "([^""]*)"$/ do |value, field|
end

Then /^he should(.*) see validation error in "([^"]*)" for "([^"]*)" if he don't choise something$/ do |should, form, locator|
  should_have_validation_error = !(should.strip == "not")

  if should_have_validation_error
    #field = find(:xpath, XPath::HTML.select(locator))
    #field = find(:xpath, XPath::HTML.fillable_field(locator))
    within("form##{form}") { page.should_not have_content("can't be blank") }
    page.driver.browser.execute_script("$('#user_time_zone').blur()")
    #page.driver.browser.execute_script("$('##{field[:id]}').blur()")

    sleep(1)

    within("form##{form}") { page.should have_content("can't be blank") }
    #fill_in(locator, with: "something")
    select("Alaska", :from => "#user_time_zone")
    #page.driver.browser.execute_script("$('#user_time_zone').val('Moscow')")
    #save_and_open_page
    page.driver.browser.execute_script("$('#user_time_zone').blur()")
    #page.driver.browser.execute_script("$('##{field[:id]}').blur()")

    sleep(1)
  end

  within("form##{form}") { page.should_not have_content("can't be blank") }
end
