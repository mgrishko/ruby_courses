require 'spec_helper'

describe "memberships/edit.html.haml" do
  before(:each) do
    @membership = assign(:membership, stub_model(Membership))
    Membership.any_instance.stub(:role_select_options).and_return([["Admin", "admin"], ["Editor", "editor"]])
  end

  describe "content" do
    it "renders edit membership form" do
      render
      rendered.should have_selector("form", action: edit_membership_path(@membership), method: "put")
    end
    
    it "renders role field" do
      render
      rendered.should have_field("membership_role", name: "membership[role]")
    end
 end
end
