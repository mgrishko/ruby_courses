require 'spec_helper'

describe AccountObserver do
  it "should create new event on account creation" do
    account = mock_model(Account)
    account.stub_chain(:memberships, :first)
    account.stub(:log_event)
    
    observer = AccountObserver.instance
    account.should_receive(:log_event)
    observer.after_create(account)
  end
end