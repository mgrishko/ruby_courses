Given /^supplier has gln (\d+) and password (\d+)$/ do |gln, password|
  User.destroy_all
  @supplier = Factory(:supplier,
  :gln => gln,
  :password => password,
  :password_confirmation => password)
end
Given /^I logged in as supplier$/ do
  visit login_path
  fill_in('Gln', :with => @supplier.gln)
  fill_in('Password', :with => @supplier.password)
  click_button('Login')
end
Given /^I have a base_item$/ do
  gpc = Factory(:gpc, :code => '10000115', :name => 'Some Name')
  item = Item.create(:user_id => @supplier.id)
  country = Factory(:country, :code => 'RU', :description => '')
  @base_item = Factory(:base_item, :user_id=>@supplier.id, :item_id=> item.id, :country_of_origin_code=> country.code, :gpc_code=> gpc.code)
end
Then /^should be visible "([^"]*)"$/ do |id|
  element = find_by_id(id)
  assert element.visible?
end

