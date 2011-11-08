require "cancan/matchers"
require 'spec_helper'

describe MembershipAbility do
  describe "admin" do
    prepare_ability_for :admin, :membership

    it { @ability.should be_able_to(:manage, :all) }
    it { @ability.should be_able_to(:read, :all) }
  end

  describe "editor" do
    prepare_ability_for :editor, :membership

    #it { @ability.should be_able_to(:manage, Company.new) }
  end

  describe "contributor" do
    prepare_ability_for :contributor, :membership
  end

  describe "viewer" do
    prepare_ability_for :viewer, :membership
  end
end