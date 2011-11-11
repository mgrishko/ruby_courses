require 'spec_helper'

describe MembershipDecorator do
  before { ApplicationController.new.set_current_view_context }

  before(:each) do
    @account = Fabricate(:account_with_memberships)
    @membership = @account.memberships.first
    @decorator = MembershipDecorator.decorate(@membership)
  end

  it "has display name" do
    @membership.user.first_name = "John"
    @membership.user.last_name = "Smith"
    @decorator.display_name.should == "John Smith"
  end
  
  it "has role name" do
    @membership.role = "editor"
    @decorator.role_name.should == "Editor"
  end
end
