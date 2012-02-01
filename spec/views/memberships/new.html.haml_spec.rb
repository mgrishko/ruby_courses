require 'spec_helper'

describe "memberships/new" do
  before(:each) do
    assign(:membership, MembershipDecorator.decorate(stub_model(Membership,
      :role => "editor"
    ).as_new_record))
  end

  describe "content" do
    it "renders new membership form" do
      render
      rendered.should have_selector("form", action: membership_invitation_path, method: "post")
    end
  end

  describe "sidebar" do
    #it "renders a back link" do
    #  render
    #  view.content_for(:sidebar).should have_selector("a", text: "Back")
    #end
  end
end
