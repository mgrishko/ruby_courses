require 'spec_helper'

describe Product do
  let(:product) { Fabricate(:product) }

  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_least(1).is_at_most(70) }
  it { should allow_mass_assignment_of(:name) }
  
  it { should validate_presence_of(:manufacturer) }
  it { should ensure_length_of(:manufacturer).is_at_least(1).is_at_most(35) }
  it { should allow_mass_assignment_of(:manufacturer) }

  it { should validate_presence_of(:brand) }
  it { should ensure_length_of(:brand).is_at_least(1).is_at_most(70) }
  it { should allow_mass_assignment_of(:brand) }

  it { should validate_presence_of(:description) }
  it { should ensure_length_of(:description).is_at_least(5).is_at_most(1000) }
  it { should allow_mass_assignment_of(:description) }

  it { should validate_presence_of(:account) }
  it { should_not allow_mass_assignment_of(:account) }

  it { should validate_presence_of(:visibility) }
  it { should allow_value("private").for(:visibility) }
  it { should allow_value("public").for(:visibility) }
  it { should_not allow_value("global").for(:visibility) }
  it { should allow_mass_assignment_of(:visibility) }

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

  it "should have many events as trackable" do
    event = product.events.build
    event.trackable.should eql(product)
  end
  
  it "should embeds many tags as tagable" do
    tag = product.tags.build
    tag.taggable.should eql(product)
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
  
  it "should create updated comment when updated without comment" do
    user = product.account.owner
    product.name = Faker::Product.product_name
    expect {
      product.save_with_system_comment(user)
      product.save
    }.to change(product.comments, :count).by(1)
    product.comments.last.body.should == "Updated by #{user.full_name}"
    product.comments.last.system.should be_true
  end
  
  it "should create updated comment when updated with comment" do
    user = product.account.owner
    product.name = Faker::Product.product_name
    comment = product.comments.build body: Faker::Lorem.sentence
    expect {
      product.save_with_system_comment(user)
    }.to change(product.comments, :count).by(1)
    product.comments.last.body.include?("Updated by #{user.full_name}").should be_true
    product.comments.last.system.should be_true
  end
  
  it "should create created comment when created without comment" do
    user = product.account.owner
    product = Fabricate.build(:product)
    expect {
      product.save_with_system_comment(user)
    }.to change(product.comments, :count).by(1)
    product.comments.last.body.should == "Created by #{user.full_name}"
    product.comments.last.system.should be_true
  end
  
  it "should create only one comment when created with comment" do
    user = product.account.owner
    product = Fabricate.build(:product)
    comment = product.comments.build body: Faker::Lorem.sentence
    expect {
      product.save_with_system_comment(user)
    }.to change(product.comments, :count).by(1)
    product.comments.last.body.include?("Created by #{user.full_name}").should be_true
    product.comments.last.system.should be_true
  end
  
  it "should create versions" do
    old_name = product.name
    product.name = Faker::Product.product_name
    product.save!
    product.name.should_not == old_name
    product.versions.first.name.should == old_name
  end

  describe "#public?" do
    context "when visibility public" do
      it "returns true" do
        product.visibility = "public"
        product.should be_public
      end
    end

    context "when visibility not public" do
      it "returns false" do
        product.visibility = "private"
        product.should_not be_public
      end
    end
  end
end
