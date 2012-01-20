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
    Membership.current = membership
    
    @trackable.events.should be_empty
    @trackable.log_event("create")
    @trackable.events.first.should be_persisted
    @trackable.events.first.action_name?("create").should be_true
    @trackable.events.first.user.should eq(@trackable.account.owner)
    @trackable.events.first.account.should eq(@trackable.account)
  end
  
  it "should log updated event" do
    membership = @trackable.account.memberships.first
    Membership.current = membership
    
    @trackable.events.should be_empty
    @trackable.log_event("update")
    @trackable.events.first.should be_persisted
    @trackable.events.first.action_name?("update").should be_true
    @trackable.events.first.user.should eq(membership.user)
    @trackable.events.first.account.should eq(membership.account)
  end
  
  it "should log destroyed event" do
    membership = @trackable.account.memberships.first
    Membership.current = membership
    
    @trackable.events.should be_empty
    @trackable.destroy
    @trackable.log_event("destroy")
    @trackable.events.first.should be_persisted
    @trackable.events.first.action_name?("destroy").should be_true
    @trackable.events.first.user.should eq(membership.user)
    @trackable.events.first.account.should eq(membership.account)
  end
  
  it "should log only one event if the eventable was updated <= 60 minutes ago" do
    membership = @trackable.account.memberships.first
    Membership.current = membership
    
    @trackable.events.should be_empty
    @trackable.log_event("update")
    Timecop.travel(Time.now + Settings.events.collapse_timeframe.minutes) do
      @trackable.log_event("update")
    end
    @trackable.events.count.should == 1
  end
  
  it "should log both update events if the eventable was updated > 60 minutes ago" do
    membership = @trackable.account.memberships.first
    Membership.current = membership
    
    @trackable.events.should be_empty
    @trackable.log_event("update")
    Timecop.travel(Time.now + (Settings.events.collapse_timeframe + 1).minutes) do
      @trackable.log_event("update")
    end
    @trackable.events.count.should == 2
  end
  
  it "should log only create event if the eventable was updated <= 60 minutes after creation" do
    membership = @trackable.account.memberships.first
    Membership.current = membership
    
    @trackable.log_event("create")
    @trackable.events.count.should == 1

    @trackable.log_event("update")
    Timecop.travel(Time.now + Settings.events.collapse_timeframe.minutes) do
      @trackable.log_event("update")
    end
    @trackable.events.count.should == 1
  end
  
  it "should log create & update event if the eventable was updated > 60 minutes after creation" do
    membership = @trackable.account.memberships.first
    Membership.current = membership
    
    @trackable.log_event("create")
    @trackable.events.count.should == 1

    @trackable.log_event("update")
    Timecop.travel(Time.now + (Settings.events.collapse_timeframe + 1).minutes) do
      @trackable.log_event("update")
    end
    
    @trackable.events.count.should == 2
  end
end
