require 'spec_helper'

describe Comment do
  let(:comment) { Fabricate(:comment) }

  it { should validate_presence_of(:body) }
  it { should ensure_length_of(:body).is_at_most(1000) }
  it { should allow_mass_assignment_of(:body) }

  it { should validate_presence_of(:user) }
  it { should allow_mass_assignment_of(:user) }
  it { should_not allow_mass_assignment_of(:user_id) }

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
end
