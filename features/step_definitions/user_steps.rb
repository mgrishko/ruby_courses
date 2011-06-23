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
  country = Factory(:country, :code => 'RU', :description => '')
  @base_item = Factory(:base_item, :user_id=>@users[role].id, :item_id => item.id, :country_of_origin_code => country.code, :gpc_code=> gpc.code)
end

When /(?:|I ) press Enter in "(.+)"$/ do |field|
  find_field(field).native.send_key(:enter)
end
Then /^I should receive file "([^"]*)"$/ do |file|
  puts (page.send(response_headers)).inspect
  result = page.response_headers['Content-Type'].should == "application/octet-stream"
  if result
    result = page.response_headers['Content-Disposition'].should =~ /#{file}/
  end
  result
end

