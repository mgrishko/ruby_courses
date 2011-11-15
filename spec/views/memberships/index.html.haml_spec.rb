require 'spec_helper'

describe "memberships/index.html.haml" do
  before(:each) do
    @ability = Object.new()
    
    @ability.extend(CanCan::Ability)
    @ability.can :manage, Membership
    controller.stub(:current_ability) { @ability }
    
    assign(:memberships, [
      stub_model(Membership, :display_name => "lname", :role_name => "Editor", :model => Membership ),
      stub_model(Membership, :display_name => "fname", :role_name => "Admin", :model => Membership)
    ])
  end

  it "renders the list of memberships" do
    render
    rendered.should have_selector("table tr", count: 3)
  end

  it "renders Name column" do
    render
    rendered.should have_selector("table th", text: "Name")
  end

  it "renders Role column" do
    render
    rendered.should have_selector("table th", text: "Role")
  end
  
  it "renders Edit link" do
    render
    rendered.should have_selector("table td a", text: "Edit")
  end
end
