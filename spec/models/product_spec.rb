require 'spec_helper'

describe Product do
  let(:product) { Fabricate(:product) }

  it { should validate_presence_of(:functional_name) }
  it { should ensure_length_of(:functional_name).is_at_least(1).is_at_most(35) }
  it { should allow_mass_assignment_of(:functional_name) }  
  
  it { should_not validate_presence_of(:variant) }
  it { should ensure_length_of(:variant).is_at_most(35) }
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
  
  it { should_not validate_presence_of(:sub_brand) }
  it { should ensure_length_of(:sub_brand).is_at_most(70) }
  it { should allow_mass_assignment_of(:sub_brand) }  
  
  it { should_not validate_presence_of(:short_description) }
  it { should ensure_length_of(:short_description).is_at_most(178) }
  it { should allow_mass_assignment_of(:short_description) }  

  it { should_not validate_presence_of(:description) }
  it { should ensure_length_of(:description).is_at_most(1000) }
  it { should allow_mass_assignment_of(:description) }
  
  it { should_not validate_presence_of(:gtin) }
  it { should allow_mass_assignment_of(:gtin) }
  it { should allow_value("12345670").for(:gtin) }
  it { should_not allow_value("12345671").for(:gtin) }
  it { should allow_value("123456789012").for(:gtin) }
  it { should_not allow_value("123456789013").for(:gtin) }
  it { should allow_value("1234567890128").for(:gtin) }
  it { should_not allow_value("1234567890129").for(:gtin) }
  it { should allow_value("12345678901231").for(:gtin) }
  it { should_not allow_value("12345678901232").for(:gtin) }

  it { should validate_presence_of(:account) }
  it { should_not allow_mass_assignment_of(:account) }

  it { should validate_presence_of(:visibility) }
  it { should allow_value("private").for(:visibility) }
  it { should allow_value("public").for(:visibility) }
  it { should_not allow_value("global").for(:visibility) }
  it { should allow_mass_assignment_of(:visibility) }

  describe "measurements" do
    context "dimensions" do
      before(:each) do
        @attrs = []
        %w(depth height width).each do |name|
          @attrs << { "name" => name, "unit" => "MM", "value" => nil }
        end
      end

      it "should be valid when all dimensions are blank" do
        product.measurements_attributes = @attrs
        product.should be_valid
      end

      it "should be valid when all dimensions are present" do
        @attrs = []
        %w(depth height width).each do |name|
          @attrs << { "name" => name, "unit" => "MM", "value" => 100 }
        end
        product.measurements_attributes = @attrs

        product.should be_valid
      end

      it "should not be valid when not all dimensions are present" do
        @attrs.first["value"] = "100"
        product.measurements_attributes = @attrs

        product.should_not be_valid
      end
    end

    context "weights" do
      before(:each) do
        @attrs = []
        %w(gross_weight net_weight).each do |name|
          @attrs << { "name" => name, "unit" => "GR", "value" => nil }
        end
      end

      it "should be valid when all weights are blank" do
        product.measurements_attributes = @attrs
        product.should be_valid
      end

      it "should be valid when gross weight presents and net weight is blank" do
        @attrs.first["value"] = "100"
        product.measurements_attributes = @attrs
        product.should be_valid
      end

      it "should not be valid when net weight presents and gross weight is blank" do
        @attrs.last["value"] = "100"
        product.measurements_attributes = @attrs
        product.should_not be_valid
      end

      it "should not be valid when net weight is greater then gross weight" do
        @attrs.first["value"] = "100"
        @attrs.last["value"] = "110"
        product.measurements_attributes = @attrs
        product.should_not be_valid
      end
    end
  end

  describe "product codes" do
    it "should be valid when all codes are blank" do
      @attrs = []
      ProductCode::IDENTIFICATION_LIST.each do |name|
        @attrs << { "name" => name, "value" => nil }
      end
      product.product_codes_attributes = @attrs
      product.should be_valid
    end
  end

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

  describe "#name" do
    it "should concat brand, sub brand, functional name and variant" do
      p = Fabricate(:product)
      expected = "#{p.brand} #{p.sub_brand} #{p.functional_name} #{p.variant}"
      p.name.should == expected
    end
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

  describe "versions" do
    it "should create new version" do
      old_name = product.functional_name
      product.functional_name = Faker::Product.product_name[0..35]
      product.save!
      product.functional_name.should_not == old_name
      product.versions.first.functional_name.should == old_name
    end
  end

  describe "auto complete" do
    before do
      product = Fabricate(:product, manufacturer: "Pepsico", brand: "Mirinda")
      product.tags.create(name: "Drink")
      product.tags.create(name: "Soft")
      @current_account = Product.first.account
    end

    it "should complete manufacturer" do
      @current_account.products.complete_manufacturer("pep").should eql(["Pepsico"])
    end

    it "should complete brand" do
      @current_account.products.complete_brand("mir").should eql(["Mirinda"])
    end

    it "should complete tags" do
      @current_account.products.complete_tags_name("dr").should eql(["Drink"])
    end

    describe "other account data" do
      before do
        product = Fabricate(:product, manufacturer: "Pepper Computers", brand: "Miranda Global")
        product.tags.create(name: "Software")
      end

      it "should not include other product field data" do
        @current_account.products.complete_manufacturer("pep").should_not include("Pepper Computers")
      end

      it "should not include other product tags" do
        @current_account.products.complete_tags_name("soft").should_not include("Software")
      end
    end
  end

  describe "#save_with_system_comment" do
    let(:user) { product.account.owner }


    it "should create updated comment when updated without comment" do
      product.functional_name = Faker::Product.product_name

      Timecop.travel(Time.now + (Settings.events.collapse_timeframe + 1).minutes) do
        expect {
          product.save_with_system_comment(user)
          product.save
        }.to change(product.comments, :count).by(1)
        product.comments.last.system.should be_true
      end
      Timecop.return
    end

    #it "should create updated comment when updated with comment" do
    #  product.functional_name = Faker::Product.product_name
    #  product.comments.build body: Faker::Lorem.sentence
    #
    #  Timecop.travel(Time.now + (Settings.events.collapse_timeframe + 1).minutes) do
    #    expect {
    #      product.save_with_system_comment(user)
    #    }.to change(product.comments, :count).by(1)
    #    product.comments.last.system.should be_true
    #  end
    #  Timecop.return
    #end

    it "should not create updated comment and new version when updated right after previous update/create" do
      product.functional_name = Faker::Product.product_name

      expect {
        product.save_with_system_comment(user)
      }.to change(product.comments, :count).by(0)
      product.version.should == 1
    end

    it "should create updated comment and new version when updated in 60 minutes after previous update/create" do
      product.functional_name = Faker::Product.product_name

      Timecop.travel(Time.now + (Settings.events.collapse_timeframe + 1).minutes) do
        expect {

          product.save_with_system_comment(user)
        }.to change(product.comments, :count).by(1)
        product.version.should == 2
      end
    end

    it "should create created comment when created without comment" do
      product = Fabricate.build(:product)
      expect {
        product.save_with_system_comment(user)
      }.to change(product.comments, :count).by(1)
      product.comments.last.system.should be_true
    end

    #it "should create only one comment when created with comment" do
    #  product = Fabricate.build(:product)
    #  product.comments.build body: Faker::Lorem.sentence
    #  expect {
    #    product.save_with_system_comment(user)
    #  }.to change(product.comments, :count).by(1)
    #  product.comments.last.system.should be_true
    #end
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
