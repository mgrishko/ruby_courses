require 'spec_helper'

describe AccountObserver do
  it "should create new event on account creation" do
    account = Fabricate(:account_with_memberships)
    account.owner = account.memberships.first.user
    observer = AccountObserver.instance
    
    expect {
      observer.after_create(account)
    }.to change(Event.unscoped, :count).by(1)
  end
end