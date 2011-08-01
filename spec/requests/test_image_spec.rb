require File.expand_path('spec/spec_helper')

describe "test image" do

  it "should create a new item without given image and item should have default image", :js => true do
    visit login_path
    fill_in 'user_session_gln', :with => '10001'
    fill_in 'user_session_password', :with => '1234'
    click_on 'user_session_submit'
  end

end
