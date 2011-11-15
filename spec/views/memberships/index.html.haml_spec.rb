require 'spec_helper'

describe "memberships/index.html.haml" do
  before(:each) do
    @account = Fabricate(:account_with_memberships)
    assign(:memberships, @account.memberships)
    
    @owner_membership = @account.memberships.select{ |m| m.role?(:admin) && m.user == @account.owner }.first
    @ability = MembershipAbility.new(@owner_membership)
    @ability.can :manage, Membership
    controller.stub(:current_ability) {@ability }
  end

  it "renders the list of memberships" do
    render
    rendered.should have_selector("table tr", count: 1 + @account.memberships.count)
  end

  it "renders Name column" do
    render
    rendered.should have_selector("table th", text: "Name")
  end

  it "renders Role column" do
    render
    rendered.should have_selector("table th", text: "Role")
  end
end
