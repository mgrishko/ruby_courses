Then /^he should(.*) see "([^"]*)" link within header$/ do |should, link|
  within("ul#account_menu") do
    if should.strip == "not"
      page.should_not have_link(link)
    else
      page.should have_link(link)
    end
  end
end

When /^(?:[^\s]*) tries to access to the account edit page$/ do
  visit(edit_account_url(subdomain: @account.subdomain))
end

When /^(?:[^\s]*) changes and submit Company name, Country, Subdomain, Timezone$/ do
  @account = Fabricate.attributes_for(:account)
  fill_in "Company name", with: @account[:company_name]
  select Carmen.country_name(@account[:country]), from: "Country"
  fill_in "Subdomain", with: @account[:subdomain]
  select @account[:time_zone], from: "Time zone"
  click_button "Update"
end

Then /^(?:[^\s]*) should be redirected to the account settings page$/ do
  current_url.should == edit_account_url(subdomain: @account.subdomain)
  #visit(edit_account_url(subdomain: @account.subdomain     ))
end
