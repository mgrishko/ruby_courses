require 'spec_helper'

describe "memberships/edit.html.haml" do
  before(:each) do
    @membership = assign(:membership, stub_model(Membership))
  end

  it "renders the edit membership form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => memberships_path(@membership), :method => "post"
  end
  
  it "renders role field" do
      render
      rendered.should have_field("membership_role", name: "membership[role]")
    end
end
