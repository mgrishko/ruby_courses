require "cancan/matchers"
require 'spec_helper'

describe MembershipAbility do

  describe "account owner" do
    prepare_ability_for :owner, :membership

    before do
      @account = @resource.account
      @owner_membership = @account.memberships.select{ |m| m.owner? }.first
    end

    it { @ability.should be_able_to(:update, @account) }
    it { @ability.should be_able_to(:update, @account) }
    it { @ability.should_not be_able_to(:update, Account.new) }
    it { @ability.should_not be_able_to(:update, @owner_membership) }
    it { @ability.should_not be_able_to(:destroy, @owner_membership) }
  end

  describe "account admin" do
    prepare_ability_for :admin, :membership

    before do
      @account = @resource.account
      @owner_membership = @account.memberships.select{ |m| m.owner? }.first
    end

    it { @ability.should_not be_able_to(:update, Account.new) }
    it { @ability.should_not be_able_to(:destroy, Account.new) }
    it { @ability.should_not be_able_to(:update, @owner_membership) }
    it { @ability.should_not be_able_to(:destroy, @owner_membership) }
    it { @ability.should be_able_to(:read, Membership) }
    it { @ability.should be_able_to(:manage, Membership.new) }
    it { @ability.should be_able_to(:manage, Product.new) }
    it { @ability.should be_able_to(:manage, Comment.new) }
    it "shouldn't be able to destroy system comment" do
      comment = Comment.new
      comment.system = true
      @ability.should_not be_able_to(:destroy, comment)
    end
    it { @ability.should be_able_to(:manage, Photo.new) }
  end

  describe "editor" do
    prepare_ability_for :editor, :membership

    before { @own_comment = Comment.new(user: @resource.user) }

    it { @ability.should_not be_able_to(:read, Membership) }
    it { @ability.should be_able_to(:manage, Product.new) }
    it { @ability.should be_able_to(:create, Comment.new) }
    it { @ability.should_not be_able_to(:destroy, Comment.new) }
    it { @ability.should be_able_to(:destroy, @own_comment) }
    it "shouldn't be able to destroy system comment" do
      @own_comment.system = true
      @ability.should_not be_able_to(:destroy, @own_comment)
    end
    it { @ability.should_not be_able_to(:update, Comment.new) }
    it { @ability.should be_able_to(:manage, Photo.new) }
  end

  describe "contributor" do
    prepare_ability_for :contributor, :membership

    before { @own_comment = Comment.new(user: @resource.user) }

    it { @ability.should_not be_able_to(:read, Membership) }
    it { @ability.should be_able_to(:read, Product) }
    it { @ability.should be_able_to(:create, Comment.new) }
    it { @ability.should_not be_able_to(:destroy, Comment.new) }
    it { @ability.should be_able_to(:destroy, @own_comment) }
    it "shouldn't be able to destroy system comment" do
      @own_comment.system = true
      @ability.should_not be_able_to(:destroy, @own_comment)
    end
    it { @ability.should_not be_able_to(:update, Comment.new) }
    it { @ability.should_not be_able_to(:manage, Photo.new) }
  end

  describe "viewer" do
    prepare_ability_for :viewer, :membership

    it { @ability.should_not be_able_to(:read, Membership) }
    it { @ability.should be_able_to(:read, Product) }
    it { @ability.should_not be_able_to(:manage, Comment.new) }
    it { @ability.should be_able_to(:read, Comment) }
    it { @ability.should_not be_able_to(:manage, Photo.new) }
  end
end
