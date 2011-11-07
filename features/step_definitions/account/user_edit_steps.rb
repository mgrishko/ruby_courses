Given /^(?:[^\s]* )is on the user edit page$/ do
  visit(edit_person_registration_url(subdomain: @account.subdomain))
end

When /^(?:[^\s]* )submits the edit form$/ do
  click_button "Update"
end

When /^(?:[^\s]* )follow "([^"]*)"$/ do |link|
  click_link(link)
end

Then /^(?:[^\s]* )should be redirected to the edit profile page$/ do
  current_url.should == edit_person_registration_url(subdomain: @account.subdomain)
end

When /^(?:[^\s]* )goes to the home page$/ do
  visit(home_url(subdomain: @account.subdomain))
end
