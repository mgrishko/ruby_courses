require 'spec_helper'

describe AccountObserver do
  it "should create new event on account creation" do
    account = mock_model(Account)
    account.stub(:log_event)
    account.stub_chain(:memberships, :first).and_return(true)
    
    observer = AccountObserver.instance
    account.should_receive(:log_event).with("create")
    observer.after_create(account)
  end
end