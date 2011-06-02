Given /^"([^"]*)" has gln "([^"]*)" and password "([^"]*)"$/ do |role, gln, password|
  User.destroy_all
  @users = {}
  @users[role] = Factory(role.to_sym,
  :gln => gln,
  :password => password,
  :password_confirmation => password)
end

Given /^I logged in as "([^"]*)"$/ do |role|
  visit login_path
  fill_in('Gln', :with => @users[role].gln)
  fill_in('Password', :with => @users[role].password)
  click_button('Login')
end

Given /^I have a base_item$/ do
  gpc = Factory(:gpc, :code => '10000115', :name => 'Some Name')
  item = Item.create(:user_id => @users['supplier'].id)
  country = Factory(:country, :code => 'RU', :description => '')
  @base_item = Factory(:base_item, :user_id=>@users['supplier'].id, :item_id => item.id, :country_of_origin_code => country.code, :gpc_code=> gpc.code)
end

When /^I attach the test image to "([^"]*)"$/ do |field|
  path = File.join(::Rails.root, 'spec', 'images', "test.jpg")
  attach_file("image", path)
end

Then /^should be visible "([^"]*)"$/ do |id|
  element = find_by_id(id)
  assert element.visible?
end

Then /^I should see new image$/ do
  img = @base_item.item.image_url
  assert find_by_id('item_image')["src"] =~ /#{img}$/
end

Then /^I new publication should not occur$/ do
  BaseItem.first(:conditions => {:status => 'published', :gtin => @base_item.gtin}, :order => " id DESC").id.should be_equal(@base_item.id)
end

Then /^I new publication should occur$/ do
  BaseItem.first(:conditions => {:status => 'published', :gtin => @base_item.gtin}, :order => "id DESC").id.should_not be_equal(@base_item.id)
end

