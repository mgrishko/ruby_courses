require 'spec_helper'

describe "password_resets/new.html.haml" do
  it "renders new password_reset form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => password_resets_path, :method => "post" do
      assert_select "input#email", :name => "email"
      assert_select "input", :name => "commit", :type => 'submit'
    end
  end
end
