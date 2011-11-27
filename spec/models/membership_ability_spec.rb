require "cancan/matchers"
require 'spec_helper'

describe MembershipAbility do

  describe "account admin" do
    prepare_ability_for :admin, :membership
    
    before do
      account = Account.first
      @owner_membership = account.memberships.select{ |m| m.owner? }.first
    end
  
    it { @ability.should_not be_able_to(:update, @owner_membership) }
    it { @ability.should_not be_able_to(:destroy, @owner_membership) }
    it { @ability.should be_able_to(:read, Membership) }
    it { @ability.should be_able_to(:manage, Membership.new) }
    it { @ability.should be_able_to(:manage, Product.new) }
    it { @ability.should be_able_to(:manage, Comment.new) }
  end
  
  describe "editor" do
    prepare_ability_for :editor, :membership

    before do
      @own_comment = Fabricate(:comment)
      @own_comment.user = @resource.user
    end

    it { @ability.should_not be_able_to(:read, Membership) }
    it { @ability.should be_able_to(:manage, Product.new) }
    it { @ability.should be_able_to(:create, Comment.new) }
    it { @ability.should_not be_able_to(:destroy, Comment.new) }
    it { @ability.should be_able_to(:destroy, @own_comment) }
    it { @ability.should_not be_able_to(:update, Comment.new) }
  end

  describe "viewer" do
    prepare_ability_for :viewer, :membership
    it { @ability.should_not be_able_to(:read, Membership) }
    it { @ability.should be_able_to(:read, Product) }
    it { @ability.should_not be_able_to(:manage, Comment.new) }
    it { @ability.should be_able_to(:read, Comment) }
  end

  describe "contributor" do
    prepare_ability_for :contributor, :membership

    before do
      @own_comment = Fabricate(:comment)
      @own_comment.user = @resource.user
    end

    it { @ability.should_not be_able_to(:read, Membership) }
    it { @ability.should be_able_to(:read, Product) }
    it { @ability.should be_able_to(:create, Comment.new) }
    it { @ability.should_not be_able_to(:destroy, Comment.new) }
    it { @ability.should be_able_to(:destroy, @own_comment) }
    it { @ability.should_not be_able_to(:update, Comment.new) }
  end
end