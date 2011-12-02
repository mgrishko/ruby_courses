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
  
  it { should respond_to :version }
  it { should respond_to :versions } 
  it { should respond_to :created_at }
  it { should respond_to :updated_at }

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
  
  it "should load versions" do
    old_name = product.name
    new_name = SecureRandom.hex(10)
    
    product.name = new_name
    product.save!
    product.name.should == new_name
    product.load_version!(1)
    product.name.should == old_name
  end
  
  it "should show that an existing version exists" do
    product.name = SecureRandom.hex(10)
    product.save!
    product.version_exists?(2).should be_true
  end
  
  it "should show that an nonexisting version does not exists" do
    product.version_exists?(666).should_not be_true
  end
  
  it "should load version datess" do
    product.name = SecureRandom.hex(10)
    product.save!
    product.get_version_dates.should eq([[2, product.updated_at], [1, product.versions.first.updated_at]])
  end
end
