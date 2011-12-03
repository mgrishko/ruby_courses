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

Then /^he should(.*) see "([^"]*)" link within sidebar$/ do |should, link|
  within(".sidebar") do
    if should.strip == "not"
      page.should_not have_link(link)
    else
      page.should have_link(link)
    end
  end
end