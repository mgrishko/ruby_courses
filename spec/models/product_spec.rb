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
  
  it "should embeds many photos" do
    photo = product.photos.build
    photo.product.should eql(product)
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
    membership = product.account.memberships.first
    
    product.events.should be_empty
    product.log_event(membership, "create")
    product.events.first.should be_persisted
    product.events.first.type?("added").should be_true
    product.events.first.user.should eq(product.account.owner)
    product.events.first.account.should eq(product.account)
  end
  
  it "should log updated event" do
    membership = product.account.memberships.first
    
    product.events.should be_empty
    product.destroy
    product.log_event(membership, "update")
    product.events.first.should be_persisted
    product.events.first.type?("updated").should be_true
    product.events.first.user.should eq(membership.user)
    product.events.first.account.should eq(membership.account)
  end
  
  it "should log destroyed event" do
    membership = product.account.memberships.first
    
    product.events.should be_empty
    product.destroy
    product.log_event(membership, "destroy")
    product.events.first.should be_persisted
    product.events.first.type?("destroyed").should be_true
    product.events.first.user.should eq(membership.user)
    product.events.first.account.should eq(membership.account)
  end
  
  it "should create updated comment when updated" do
    user = product.account.owner
    expect {
      product.create_updated_comment(user)
    }.to change(product.comments, :count).by(1)
    product.comments.last.body.should == "Updated by #{user.full_name}"
    product.comments.last.system.should be_true
  end
  
  it "should be found as trackable" do
    Product.find_trackable(product.id).should eq(product)
  end
  
  it "should be found as trackable even if deleted" do
    product.destroy
    Product.find_trackable(product.id).should eq(product)
  end
end
