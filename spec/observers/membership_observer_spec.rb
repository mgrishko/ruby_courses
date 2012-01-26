require 'spec_helper'

describe MembershipObserver do
  it "should create new event on membership creation" do
    Membership.current = Fabricate(:membership)
    membership = Fabricate(:membership)
    observer = MembershipObserver.instance
    
    expect {
      observer.after_create(membership)
    }.to change(Event.unscoped, :count).by(1)
  end
end