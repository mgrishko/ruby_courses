When /^he follows "([^"]*)" within (.*)$/ do |link, scope|
  within(".#{scope}") do
    click_on(link)
  end
end