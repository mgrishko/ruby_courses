require 'spec_helper'

describe PhotoObserver do
  before(:each) do
    @photo = Fabricate(:photo)
    Membership.current = Fabricate(:membership)
    @observer = PhotoObserver.instance
  end
  
  it "should create new event on photo creation" do
    expect {
      @observer.after_create(@photo)
    }.to change(Event.unscoped, :count).by(1)
    
    Event.last.action_name.should == "create"
  end
  
  it "should create destroy event on photo deletion" do
    expect {
      @observer.after_destroy(@photo)
    }.to change(Event.unscoped, :count).by(1)
    
    Event.last.action_name.should == "destroy"
  end
end
