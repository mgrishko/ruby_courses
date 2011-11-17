require 'spec_helper'

describe MembershipDecorator do
  before { ApplicationController.new.set_current_view_context }

  before(:each) do
    @membership = Fabricate(:membership)
    @decorator = MembershipDecorator.decorate(@membership)
  end

  it "has display name" do
    @decorator.display_name.should == "#{@membership.user.first_name} #{@membership.user.last_name}"
  end
  
  it "has role name" do
    @decorator.role_name.should == @membership.role.capitalize
  end
  
  it "has role_select_options" do
    @decorator.role_select_options.should == [["Admin", "admin"], ["Editor", "editor"], ["Contributor", "contributor"], ["Viewer", "viewer"]]
  end
end
