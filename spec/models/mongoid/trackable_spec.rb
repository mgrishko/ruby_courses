require 'spec_helper'

describe Mongoid::Trackable do
  let(:event) { Fabricate(:event) }

  before(:each) do
    @trackable = Fabricate(:product)
  end

  it "should have many events" do
    event = @trackable.events.build
    @trackable.events.should include(event)
  end
  
  it "should log added event" do
    membership = @trackable.account.memberships.first
    
    @trackable.events.should be_empty
    @trackable.log_event(membership, "create")
    @trackable.events.first.should be_persisted
    @trackable.events.first.action_name?("create").should be_true
    @trackable.events.first.user.should eq(@trackable.account.owner)
    @trackable.events.first.account.should eq(@trackable.account)
  end
  
  it "should log updated event" do
    membership = @trackable.account.memberships.first
    
    @trackable.events.should be_empty
    @trackable.destroy
    @trackable.log_event(membership, "update")
    @trackable.events.first.should be_persisted
    @trackable.events.first.action_name?("update").should be_true
    @trackable.events.first.user.should eq(membership.user)
    @trackable.events.first.account.should eq(membership.account)
  end
  
  it "should log destroyed event" do
    membership = @trackable.account.memberships.first
    
    @trackable.events.should be_empty
    @trackable.destroy
    @trackable.log_event(membership, "destroy")
    @trackable.events.first.should be_persisted
    @trackable.events.first.action_name?("destroy").should be_true
    @trackable.events.first.user.should eq(membership.user)
    @trackable.events.first.account.should eq(membership.account)
  end
end
