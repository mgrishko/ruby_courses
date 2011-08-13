require 'spec_helper'

describe "password_resets/edit.html.haml" do
  before(:each) do
    @user = assign(:password_reset, stub_model(User, {
      :new_record? => false,
      :id => 5,
    }))
    assigns[:user] = @user
    params[:id] = '555'
    ActionController::Base.default_url_options.update :id => '565'
  end

  after :all do
    ActionController::Base.default_url_options.delete :id
  end

  it "renders the edit password_reset form" do
    render

    assert_select "form", :action => password_reset_path(@user), :method => "post" do
      assert_select "input#password", :name => "password"
      assert_select "input#password_confirmation", :name => "password_confirmation"
      assert_select "input", :name => "commit", :type => 'submit'
    end
  end
end
