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