require 'spec_helper'

describe Comment do
  let(:comment) { Fabricate(:comment) }

  it { should validate_presence_of(:body) }
  it { should ensure_length_of(:body).is_at_most(1000) }
  it { should allow_mass_assignment_of(:body) }

  it { should validate_presence_of(:user) }
  it { should allow_mass_assignment_of(:user) }
  it { should_not allow_mass_assignment_of(:user_id) }
  
  it { should_not allow_mass_assignment_of(:system) }

  it "should be embedded in commentable" do
    product = Fabricate(:product)
    comment = product.comments.build
    comment.commentable.should eql(product)
  end
  
  it "should have many events as trackable" do
    event = comment.events.build
    event.trackable.should eql(comment)
  end
  
  it "should belong to user" do
    user = Fabricate(:user)
    comment = Fabricate(:comment, user: user)
    comment.user.should eql(user)
  end

  it "should set created_at" do
    Timecop.freeze
    comment = Fabricate(:comment)
    comment.created_at.should == Time.now
    Timecop.return
  end
  
  it "should log added event" do
    membership = comment.commentable.account.memberships.first
    
    comment.events.should be_empty
    comment.log_event(membership, "create")
    comment.events.first.should be_persisted
    comment.events.first.type?("added").should be_true
    comment.events.first.user.should eq(membership.user)
    comment.events.first.account.should eq(membership.account)
  end
  
  it "should log updated event" do
    membership = comment.commentable.account.memberships.first
    
    comment.events.should be_empty
    comment.destroy
    comment.log_event(membership, "update")
    comment.events.first.should be_persisted
    comment.events.first.type?("updated").should be_true
    comment.events.first.user.should eq(membership.user)
    comment.events.first.account.should eq(membership.account)
  end
  
  it "should log destroyed event" do
    membership = comment.commentable.account.memberships.first
    
    comment.events.should be_empty
    comment.destroy
    comment.log_event(membership, "destroy")
    comment.events.first.should be_persisted
    comment.events.first.type?("destroyed").should be_true
    comment.events.first.user.should eq(membership.user)
    comment.events.first.account.should eq(membership.account)
  end
  
  it "should not be destroyed if system" do
    comment.system = true
    comment.destroy.should be_false
  end
end
