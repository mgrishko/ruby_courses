Given /^"([^"]*)" has gln "([^"]*)" and password "([^"]*)"$/ do |role, gln, password|
  @users ||= {}
  ActiveRecord::Base.connection.execute("TRUNCATE users") unless @users.any?
  @users[role] = Factory(role.to_sym,
  :gln => gln,
  :password => password,
  :password_confirmation => password)
end

Given /^I logged in as "([^"]*)"$/ do |role|
  visit login_path
  fill_in('user_session_gln', :with => @users[role].gln)
  fill_in('user_session_password', :with => @users[role].password)
  click_button('user_session_submit')
end

Given /^I have a base_item$/ do
  gpc = Factory(:gpc, :code => '10000115', :name => 'Some Name')
  item = Item.create(:user_id => @users['supplier'].id)
  country = Factory(:country, :code => 'RU', :description => '')
  @base_item = Factory(:base_item, :user_id=>@users['supplier'].id, :item_id => item.id, :country_of_origin_code => country.code, :gpc_code=> gpc.code)
end

Given /^I have a base_item with gtin "([^"]*)"$/ do |gtin|
  gpc = Factory(:gpc, :code => '10000115', :name => 'Some Name')
  item = Item.create(:user_id => @users['supplier'].id)
  country = Factory(:country, :code => 'RU', :description => '')
  @base_item = Factory(:base_item, :gtin=>gtin, :user_id=>@users['supplier'].id, :item_id => item.id, :country_of_origin_code => country.code, :gpc_code=> gpc.code)
end

When /^I attach the test image to "([^"]*)"$/ do |field|
  path = File.join(Rails.root, 'spec', 'images', "test.jpg")
  attach_file(field, path)
end

Then /^should not be visible "([^"]*)"$/ do |id|
  element = nil
  begin
    element = find_by_id(id)
  rescue
  end
  if element.present?
    assert !element.visible?
  else
    assert true
  end
end

Then /^should be visible "([^"]*)"$/ do |id|
  element = find_by_id(id)
  assert element.visible?
end

Then /^element "([^"]*)" should be disabled$/ do |selector|
  assert find(selector)['disabled']
end

Then /^I should see new image$/ do
  img = @base_item.image_url('tile')
  assert find_by_id('item_image')["src"] =~ /#{img}$/
end

Then /^I should see appropriate image$/ do
  BaseItem.all.each do |base_item|
    img = base_item.image_url('tile')
    assert find_by_id('img')["src"] =~ /#{img}$/
  end
end



Then /^I new publication should not occur$/ do
  BaseItem.first(:conditions => {:status => 'published', :gtin => @base_item.gtin}, :order => " id DESC").id.should be_equal(@base_item.id)
end

Then /^I new publication should occur$/ do
  BaseItem.first(:conditions => {:status => 'published', :gtin => @base_item.gtin}, :order => "id DESC").id.should_not be_equal(@base_item.id)
end

When /^I wait for (\d+) second(?:|s)$/ do |time|
  sleep time.to_i
end

When /^I click element "([^"]*)"(?: within "([^"]*)")?$/ do |id,selector|
  with_scope(selector) do
    find(id).click
  end
end


When /^(?:|I )fill in hidden_field "([^"]*)" with "([^"]*)"(?: within "([^"]*)")?$/ do |field, value, selector|
  with_scope(selector) do
    page.execute_script("$('##{field}').val('#{value}');")
  end
end

