require 'spec_helper'

describe "memberships/new.html.haml" do
  before(:each) do
    assign(:membership, MembershipDecorator.decorate(Fabricate.build(:membership)))
  end

  describe "content" do
    it "renders new membership form" do
      render
      rendered.should have_selector("form", action: membership_invitation_path, method: "post")
    end
  end

  describe "sidebar" do
    it "renders a back link" do
      render
      view.content_for(:sidebar).should have_selector("a", text: "Back")
    end
  end
end
