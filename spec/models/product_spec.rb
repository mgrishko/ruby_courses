require 'spec_helper'

describe Product do
  let(:product) { Fabricate(:product) }

  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_least(1).is_at_most(70) }
  it { should allow_mass_assignment_of(:name) }
  
  it { should validate_presence_of(:description) }
  it { should ensure_length_of(:description).is_at_least(5).is_at_most(1000) }
  it { should allow_mass_assignment_of(:description) }

  it { should validate_presence_of(:account) }
  it { should_not allow_mass_assignment_of(:account) }

  it "should belong to account" do
    account = Fabricate(:account)
    product = account.products.build
    product.account.should eql(account)
  end

  it "should embeds many comments as commentable" do
    comment = product.comments.build
    comment.commentable.should eql(product)
  end

  it "should have many events as trackable" do
    event = product.events.build
    event.trackable.should eql(product)
  end

  it "should set created_at" do
    Timecop.freeze
    product = Fabricate(:product)
    product.created_at.should == Time.now
    Timecop.return
  end

  it "should set updated_at" do
    Timecop.freeze
    product.save!
    product.updated_at.should == Time.now
    Timecop.return
  end
  
  it "should log added event" do
    product.events.should be_empty
    product.log_event(product.account.owner, "create")
    product.events.first.should be_persisted
    product.events.first.type?("added").should be_true
    product.events.first.user.should eq(product.account.owner)
    product.events.first.account.should eq(product.account)
  end
end
