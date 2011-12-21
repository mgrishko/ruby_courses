require 'spec_helper'

describe Product do
  let(:product) { Fabricate(:product) }

  it { should validate_presence_of(:functional_name) }
  it { should ensure_length_of(:functional_name).is_at_least(1).is_at_most(35) }
  it { should allow_mass_assignment_of(:functional_name) }  
  
  it { should validate_presence_of(:variant) }
  it { should ensure_length_of(:variant).is_at_least(1).is_at_most(35) }
  it { should allow_mass_assignment_of(:variant) }    
  
  it { should validate_presence_of(:manufacturer) }
  it { should ensure_length_of(:manufacturer).is_at_least(1).is_at_most(35) }
  it { should allow_mass_assignment_of(:manufacturer) }

  it { should validate_presence_of(:country_of_origin) }
  it { should allow_value("US").for(:country_of_origin) }
  it { should_not allow_value("ZZZ").for(:country_of_origin) }
  it { should allow_mass_assignment_of(:country_of_origin) }
  
  it { should validate_presence_of(:brand) }
  it { should ensure_length_of(:brand).is_at_least(1).is_at_most(70) }
  it { should allow_mass_assignment_of(:brand) }
  
  it { should validate_presence_of(:sub_brand) }
  it { should ensure_length_of(:sub_brand).is_at_least(1).is_at_most(70) }
  it { should allow_mass_assignment_of(:sub_brand) }  
  
  it { should validate_presence_of(:short_description) }
  it { should ensure_length_of(:short_description).is_at_least(1).is_at_most(178) }
  it { should allow_mass_assignment_of(:short_description) }  

  it { should validate_presence_of(:description) }
  it { should ensure_length_of(:description).is_at_least(5).is_at_most(1000) }
  it { should allow_mass_assignment_of(:description) }
  
  it { should validate_presence_of(:gtin) }
  it { should ensure_length_of(:gtin).is_equal_to(14) }
  it { should allow_mass_assignment_of(:gtin) }
  it { should allow_value("00000123456789").for(:gtin) }
  it { should_not allow_value("0abcdefghijklm").for(:gtin) }

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
  
  it "should embeds many measurements" do
    measurement = product.measurements.build
    measurement.product.should eql(product)
  end

  it "should embeds many product_codes" do
    product_code = product.product_codes.build
    product_code.product.should eql(product)
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
    product.short_description = Faker::Product.product_name
    
    Timecop.travel(Time.now + (Settings.events.collapse_timeframe + 1).minutes) do
      expect {
        product.save_with_system_comment(user)
        product.save
      }.to change(product.comments, :count).by(1)
      product.comments.last.system.should be_true
    end
    Timecop.return
  end
  
  it "should create updated comment when updated with comment" do
    user = product.account.owner
    product.short_description = Faker::Product.product_name
    product.comments.build body: Faker::Lorem.sentence
    Timecop.travel(Time.now + (Settings.events.collapse_timeframe + 1).minutes) do
      expect {
        product.save_with_system_comment(user)
      }.to change(product.comments, :count).by(1)
      product.comments.last.system.should be_true
    end
    Timecop.return
  end
  
  it "should not create updated comment and new version when updated right after previous update/create" do
    user = product.account.owner
    
    expect {
      product.short_description = Faker::Product.product_name
      product.save_with_system_comment(user)
    }.to change(product.comments, :count).by(0)
    product.version.should == 1
  end
  
  it "should create updated comment and new version when updated in 60 minutes after previous update/create" do
    user = product.account.owner
    
    Timecop.travel(Time.now + (Settings.events.collapse_timeframe + 1).minutes) do
      expect {
        product.short_description = Faker::Product.product_name
        product.save_with_system_comment(user)
      }.to change(product.comments, :count).by(1)
      product.version.should == 2
    end
  end
  
  it "should create created comment when created without comment" do
    user = product.account.owner
    product = Fabricate.build(:product)
    expect {
      product.save_with_system_comment(user)
    }.to change(product.comments, :count).by(1)
    product.comments.last.system.should be_true
  end
  
  it "should create only one comment when created with comment" do
    user = product.account.owner
    product = Fabricate.build(:product)
    product.comments.build body: Faker::Lorem.sentence
    expect {
      product.save_with_system_comment(user)
    }.to change(product.comments, :count).by(1)
    product.comments.last.system.should be_true
  end
  
  it "should create versions" do
    old_description = product.short_description
    product.short_description = Faker::Product.product_name
    product.save!
    product.short_description.should_not == old_description
    product.versions.first.short_description.should == old_description
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
