require 'spec_helper'

describe MembershipObserver do
  it "should create new event on membership creation" do
    membership = mock_model(Membership)
    membership.stub(:invited_by).and_return(true)
    
    observer = MembershipObserver.instance
    membership.should_receive(:log_event).with(membership, "create")
    observer.after_create(membership)
  end
end