require "cancan/matchers"
require 'spec_helper'

describe MembershipAbility do
  before(:all) do
    @account = Fabricate(:account_with_memberships)
    @owner_membership = @account.memberships.select{ |m| m.role?(:admin) && m.user == @account.owner }.first
    @admin_membership = @account.memberships.select{ |m| m.role?(:admin) && m.user != @account.owner }.first
    @editor_membership = @account.memberships.select{ |m| m.role?(:editor)}.first
    @non_owner_memberships = @account.memberships.select{ |m| m.user != @account.owner }
  end
  
  describe "account owner" do
    before do
      @ability = MembershipAbility.new(@owner_membership)
    end
    
    it { @ability.should_not be_able_to(:destroy, @owner_membership) }
    it { @ability.should_not be_able_to(:update, @owner_membership) }
    it { @ability.should be_able_to(:read, @owner_membership) }
    
    it "should manage non owners" do
      @non_owner_memberships.each do |m|
        @ability.should be_able_to(:destroy, m)
        @ability.should be_able_to(:update, m)
        @ability.should be_able_to(:read, m)
      end 
    end
  end

  describe "admin" do
    before do
      @ability = MembershipAbility.new(@admin_membership)
    end
    
    it { @ability.should_not be_able_to(:destroy, @owner_membership) }
    it { @ability.should_not be_able_to(:update, @owner_membership) }
    it { @ability.should be_able_to(:read, @owner_membership) }
    
    it "should manage non owners" do
      @non_owner_memberships.each do |m|
        @ability.should be_able_to(:destroy, m)
        @ability.should be_able_to(:update, m)
        @ability.should be_able_to(:read, m)
      end 
    end
  end

  describe "editor" do
    before do
      @ability = MembershipAbility.new(@editor_membership)
    end
    
    it { @ability.should_not be_able_to(:read, Membership) }
    it { @ability.should be_able_to(:manage, Product.new) }
  end

  describe "viewer" do
    prepare_ability_for :viewer, :membership

    it { @ability.should_not be_able_to(:read, Membership) }
    it { @ability.should be_able_to(:read, Product) }
  end

  describe "contributor" do
    prepare_ability_for :contributor, :membership
    it { @ability.should_not be_able_to(:read, Membership) }
    #it { @ability.should be_able_to(:read, Product) }
  end
end