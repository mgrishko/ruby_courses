Then /^(?:[^\s]*) should (.*) see account settings link in menu$/ do |visible|
  if visible == 'not'
    page.should have_no_xpath('smth')
  elsif visible.empty?
    page.should have_xpath('smth')
  end
end

When /^(?:[^\s]*) tries access to the account edit page$/ do
  visit(edit_account_url(subdomain: @account.subdomain))
end

When /^(?:[^\s]*) change and submits Company name, Country, Subdomain, Timezone$/ do |password|
  @account = Fabricate.attributes_for(:account)
  fill_in "Company name", with: @account[:company_name]
  fill_in "Country", with: @account[:country]
  fill_in "Subdomain", with: @account[:subdomain]
  fill_in "Timezone", with: @account[:time_zone]
  click_button "Update"
end

Then /^(?:[^\s]*) should be redirected to the account settings page$/ do
  current_url.should == edit_account_url(subdomain: @account.subdomain)
end
