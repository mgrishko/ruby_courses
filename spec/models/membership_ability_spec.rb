require "cancan/matchers"
require 'spec_helper'

describe MembershipAbility do

  describe "account admin" do
    before do
      @account = Fabricate(:account_with_memberships)
      @owner_membership = @account.memberships.select{ |m| m.role?(:admin) && m.owner? }.first
      @admin_membership = @account.memberships.select{ |m| m.role?(:admin) && !m.owner? }.first
      @ability = MembershipAbility.new(@admin_membership)
    end
  
    it { @ability.should_not be_able_to(:update, @owner_membership) }
    it { @ability.should_not be_able_to(:destroy, @owner_membership) }
    it { @ability.should be_able_to(:read, @owner_membership) }
  
    it "should manage all roles except for owners" do
      @account.memberships.select{ |m| !m.owner? }.each do |membership|
        @ability.should be_able_to(:manage, membership)
      end 
    end
    
    it { @ability.should be_able_to(:manage, Product.new) }
  end
  
  describe "editor" do
    prepare_ability_for :editor, :membership
    
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
  end
end