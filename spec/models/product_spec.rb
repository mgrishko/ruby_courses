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

  it "should accept nested attributes for comment" do
    current_user = Fabricate(:user)
    comment = product.comments.build(Fabricate.attributes_for(:comment, commentable: nil, user: nil))
    product.comments.each { |c| c.user = current_user }
    product.save!
    product.reload
    product.comments.should include(comment)
  end
end
