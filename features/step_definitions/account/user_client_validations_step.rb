Then /^he should(.*) see error in "([^"]*)" for "([^"]*)" if he clear select field$/ do
                                                                              |should, form, locator|
  should_have_validation_error = !(should.strip == "not")

  if should_have_validation_error
    field = find(:xpath, XPath::HTML.select(locator))
    within("form##{form}") { page.should_not have_content("can't be blank") }
    page.driver.browser.execute_script("$('##{field[:id]}').val('')")
    page.driver.browser.execute_script("$('##{field[:id]}').keyup()")

    sleep(2)

    within("form##{form}") { page.should have_content("can't be blank") }
    page.driver.browser.execute_script("$('##{field[:id]}').val('Moscow')")
    page.driver.browser.execute_script("$('##{field[:id]}').keyup()")

    sleep(2)
  end

  within("form##{form}") { page.should_not have_content("can't be blank") }
end

Then /^he should(.*) see error in "([^"]*)" for "([^"]*)" if he don't choice something$/ do
                                                                                  |should, form, locator|
  should_have_validation_error = !(should.strip == "not")

  if should_have_validation_error
    field = find(:xpath, XPath::HTML.select(locator))
    within("form##{form}") { page.should_not have_content("can't be blank") }
    page.driver.browser.execute_script("$('##{field[:id]}').keyup()")

    sleep(2)

    within("form##{form}") { page.should have_content("can't be blank") }
    page.driver.browser.execute_script("$('##{field[:id]}').val('Moscow')")
    page.driver.browser.execute_script("$('##{field[:id]}').keyup()")

    sleep(2)
  end

  within("form##{form}") { page.should_not have_content("can't be blank") }
end

Then /^he should(.*) see error in "([^"]*)" for "([^"]*)" if he clear it$/ do
                                                                    |should, form, locator|
  should_have_validation_error = !(should.strip == "not")

  if should_have_validation_error
    field = find(:xpath, XPath::HTML.fillable_field(locator))
    page.driver.browser.execute_script("$('##{field[:id]}').val('')")
    page.driver.browser.execute_script("$('##{field[:id]}').keyup()")

    sleep(2)

    within("form##{form}") { page.should have_content("can't be blank") }
    fill_in(locator, with: locator == "Email" ? "foo@bar.com" : "something")
    page.driver.browser.execute_script("$('##{field[:id]}').keyup()")

    sleep(2)
  end

  within("form##{form}") do
    page.should_not have_content(
      locator == "Email" ? ( "can't be blank" || "is invalid") : "can't be blank"
    )
  end
end

# For edit account form

Then /^he should(.*) see error in edit_account for "([^"]*)" if he clear it$/ do
                                                                            |should, locator|
  should_have_validation_error = !(should.strip == "not")

  if should_have_validation_error
    field = find(:xpath, XPath::HTML.fillable_field(locator))
    page.driver.browser.execute_script("$('##{field[:id]}').val('')")
    page.driver.browser.execute_script("$('##{field[:id]}').keyup()")

    sleep(2)

    within("form.edit_account") { page.should have_content("can't be blank") }
    fill_in(locator, with: locator == "Email" ? "foo@bar.com" : "something")
    page.driver.browser.execute_script("$('##{field[:id]}').keyup()")

    sleep(2)
  end

  within("form.edit_account") do
    page.should_not have_content(
      locator == "Email" ? ( "can't be blank" || "is invalid") : "can't be blank"
    )
  end
end

Then /^he should(.*) see error in edit_account for "([^"]*)" if he clear select field$/ do
                                                                                      |should, locator|
  should_have_validation_error = !(should.strip == "not")

  if should_have_validation_error
    field = find(:xpath, XPath::HTML.select(locator))
    within("form.edit_account") { page.should_not have_content("can't be blank") }
    page.driver.browser.execute_script("$('##{field[:id]}').val('')")
    page.driver.browser.execute_script("$('##{field[:id]}').keyup()")

    sleep(2)

    within("form.edit_account") { page.should have_content("can't be blank") }
    page.driver.browser.execute_script("$('##{field[:id]}').val('Moscow')")
    page.driver.browser.execute_script("$('##{field[:id]}').keyup()")

    sleep(2)
  end

  within("form.edit_account") { page.should_not have_content("can't be blank") }
end

Then /^he should not see validation errors in edit_account form$/ do
  within("form.edit_account") { page.should_not have_content("can't be blank") }
end

