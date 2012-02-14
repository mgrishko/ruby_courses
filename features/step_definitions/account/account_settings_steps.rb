When /^(?:[^\s]*) tries to access to the account edit page$/ do
  visit edit_account_path
end

When /^(?:[^\s]*) changes and submit Company name, Country, Subdomain, Timezone$/ do
  @account = Fabricate.attributes_for(:account)
  fill_in "Company", with: @account[:company_name]
  select Carmen.country_name(@account[:country]), from: "Country"
  fill_in "Subdomain", with: @account[:subdomain]
  fill_in "Website", with: @account[:website]
  fill_in "A few words about your company", with: @account[:about_company]
  select @account[:time_zone], from: "Time zone"
  click_button "Update"
end

Then /^(?:[^\s]*) should be redirected to the account settings page$/ do
  extract_port(current_url).should == edit_account_url(subdomain: @account.subdomain)
end

Then /^(?:[^\s]*) should be on the account login page$/ do
  extract_port(current_url).should == new_user_session_url(subdomain: @account.subdomain)
end
