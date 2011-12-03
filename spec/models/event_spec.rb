require 'spec_helper'

describe Event do
  let(:event) { Fabricate(:event) }
  
  it { should validate_presence_of(:account) }
  it { should validate_presence_of(:user) }
  
  it { should validate_presence_of(:type) }
  it { should allow_value("added").for(:type) }
  it { should allow_value("updated").for(:type) }
  it { should allow_value("destroyed").for(:type) }
  it { should_not allow_value("whatever").for(:type) }
  
  it "should belong to account" do
    account = Fabricate(:account)
    event = account.events.build
    event.account.should eql(account)
  end
  
  it "should belong to user" do
    user = Fabricate(:user)
    event = user.events.build
    event.user.should eql(user)
  end
  
  it "should belong to trackable" do
    product = Fabricate(:product)
    event = product.events.build
    event.trackable.should eql(product)
  end
  
end
