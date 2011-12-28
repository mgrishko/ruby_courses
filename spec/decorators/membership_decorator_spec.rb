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

    describe "#invitation_label" do
      it "#invitation_label" do
        @decorator.invitation_note.should == @membership.invitation_note
        @decorator.invited_by.first_name.should == @membership.invited_by.first_name
      end

      it "render html type" do
        @decorator.invitation_label(format: :html).should ==
          "<p>\n#{@membership.invited_by.first_name}\nalso says:\n</p><pre>#{@membership.invitation_note}</pre>"
      end

      it "render text type" do
        @decorator.invitation_label(format: :text).should ==
          "#{@membership.invited_by.first_name} also says:\n#{@membership.invitation_note}"
      end
    end

    describe "#password_label" do
      it "#password_label" do
        @decorator.user.password.should == @membership.user.password
      end

      it "render text type" do
        @decorator.password_label(format: :text).should ==
        "Password:\n#{@membership.user.password}"
      end

      it "render html type" do
        @decorator.password_label(format: :html).should ==
        "Password:\n<br>\n#{@membership.user.password}"
      end
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
