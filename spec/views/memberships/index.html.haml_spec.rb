require 'spec_helper'

describe "memberships/index.html.haml" do
  before(:each) do
    @membership = stub_model(Membership, :display_name => "lname", :role_name => "Editor", :model => Membership )
    Membership.any_instance.stub(:edit_link).and_return("<a>Edit</a>")
    Membership.any_instance.stub(:destroy_link).and_return("<a>Destroy</a>")
    
    assign(:memberships, [@membership])
  end

  it "renders the list of memberships" do
    render
    rendered.should have_selector("table tr", count: 2)
  end

  it "renders Name column" do
    render
    rendered.should have_selector("table th", text: "Name")
  end

  it "renders Role column" do
    render
    rendered.should have_selector("table th", text: "Role")
  end
  
  it "renders role value" do
    render
    rendered.should have_selector("table td", text: "Editor")
  end
  
  it "renders display_name value" do
    render
    rendered.should have_selector("table td", text: "lname")
  end
  
  it "renders Edit link" do
    render
    rendered.should have_selector("table td", text: "Edit")
  end
  
  it "renders Destroy link" do
    render
    rendered.should have_selector("table td", text: "Destroy")
  end
end
