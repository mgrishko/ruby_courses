class BaseItem
  def country
    'Russia'
  end
end
Given /^"([^"]*)" has gln "([^"]*)" and password "([^"]*)" also$/ do |role, gln, password|
  @users = {} unless @users
  @users[role] = Factory(role.to_sym,
  :gln => gln,
  :password => password,
  :password_confirmation => password)
end

When /^(?:|I )go with "(.+)" to (.+)$/ do |url, page_name|
  visit path_to(page_name)+url.to_s
end

Given /^"(.+)" has a base_item$/ do |role|
  gpc = Factory(:gpc, :code => '10000115', :name => 'Some Name')
  item = Item.create(:user_id => @users[role].id)
  country = Factory(:country)
  #country = Factory(:country, :code => 'RU', :description => '')
  @base_item = Factory(:base_item, :user_id=>@users[role].id, :item_id => item.id, :country_of_origin_code => country.code, :gpc_code=> gpc.code)
  @base_item.country = 'Russia'
end

When /(?:|I ) press Enter in "(.+)"$/ do |field|
  find_field(field).native.send_key(:enter)
end

Then /^I should receive file$/ do
#  pending 'Capybara::NotSupportedByDriverError'
#  (result = page.response_headers['Content-Type']).should == "application/octet-stream"
#  if result
#    result = page.response_headers['Content-Disposition'].should =~ /#{file}/
#  end
#  result
end

When /(?:|I ) confirm action$/ do
  page.evaluate_script('window.confirm = function() { return true; }')
end

Then /^I accept the alert$/ do
  page.driver.browser.switch_to.alert.accept
end
