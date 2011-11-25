require 'spec_helper'

describe MembershipDecorator do
  before { ApplicationController.new.set_current_view_context }

  before(:each) do
    @user = Fabricate(:user)
    @membership = Fabricate(:membership, user: @user)
    @decorator = MembershipDecorator.decorate(@membership, role: "editor")
  end

  describe "decorates" do
    it "#display_name" do
      @decorator.display_name.should == @user.full_name
    end

    it "#role_name" do
      @decorator.role_name.should == "Editor"
    end

    it "#email" do
      @decorator.email.should == @membership.user.email
    end
    
    it "#role_select_options" do
      MembershipDecorator.role_select_options.should ==
          [["Admin", "admin"], ["Editor", "editor"], ["Contributor", "contributor"], ["Viewer", "viewer"]]
    end

    describe "#setup_nested" do
      before(:each) do
        @membership = Membership.new
        @decorator = MembershipDecorator.decorate(@membership)
      end

      it "builds user" do
        @decorator.setup_nested
        @decorator.user.should_not be_nil
      end

      it "returns self" do
        decorator = @decorator.setup_nested
        decorator.should eql(@decorator)
      end

      it "doesn't build user if it is not nil" do
        user = User.new
        @membership.user = user
        @decorator.setup_nested
        @decorator.user.should eql(user)
      end
    end
  end

  describe "#invitation_link" do
    context "when user can invite a new member" do
      it "renders link" do
        @decorator.h.stub(:can?).and_return(true)
        MembershipDecorator.invitation_link.should_not be_blank
      end
    end

    context "when user cannot invite a new member" do
      it "should return empty string" do
        @decorator.h.stub(:can?).and_return(false)
        MembershipDecorator.invitation_link.should be_blank
      end
    end
  end
end