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
  it { should allow_value("6291041500213").for(:gtin) }
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

  it { should respond_to :version }
  it { should respond_to :versions }
  it { should respond_to :created_at }
  it { should respond_to :updated_at }

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

  it "should embeds many comments as commentable" do
    comment = product.comments.build
    comment.commentable.should eql(product)
  end

  it "should embeds many packages" do
    package = product.packages.build
    package.product.should eql(product)
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

  describe "search filters" do
    before do
      @product1 = Fabricate(:product,
                            functional_name: "Functional 1",
                            variant: "Variant 1",
                            brand: "Brand 1",
                            sub_brand: "Sub Brand 1",
                            manufacturer: "Manufacturer 1")
      @product2 = Fabricate(:product,
                            functional_name: "Functional 2",
                            variant: "Variant 2",
                            brand: "Brand 2",
                            sub_brand: "Sub Brand 2",
                            manufacturer: "Manufacturer 2")

      2.times { |i| @product1.tags.create(name: "Tag #{i + 1}") }
      3.times { |i| @product2.tags.create(name: "Tag #{i + 1}") }
    end

    describe "#by_brand" do
      specify { Product.by_brand("brand 1").should include(@product1) }
      specify { Product.by_brand("brand 1").should_not include(@product2) }
    end

    describe "#by_manufacturer" do
      specify { Product.by_manufacturer("Manufacturer 1").should include(@product1) }
      specify { Product.by_manufacturer("Manufacturer 1").should_not include(@product2) }
    end

    describe "#by_tags_name" do
      specify { Product.by_tags_name("tag 1").should include(@product1) }
      specify { Product.by_tags_name("tag 2").should include(@product2) }
      specify { Product.by_tags_name("tag 3").should_not include(@product1) }
    end

    describe "#by_functional_name" do
      specify { Product.by_functional_name("functional 1").should include(@product1) }
      specify { Product.by_functional_name("functional 1").should_not include(@product2) }
    end
  end

  describe "distinct values methods" do
    before do
      product = Fabricate(:product,
                          manufacturer: "Pepsico",
                          brand: "Pepsi",
                          sub_brand: "Mirinda",
                          variant: "Light",
                          functional_name: "Soft drink")
      product.tags.create(name: "Drink")
      product.tags.create(name: "Soft")
      @current_account = Product.first.account
    end

    it "should return all values if is called without search query" do
      Fabricate(:product, manufacturer: "Pepsico", brand: "Tarhun", account: @current_account)
      @current_account.products.distinct_brands.should eql(["Pepsi", "Tarhun"])
    end

    it "should return manufacturers" do
      @current_account.products.distinct_manufacturers(search: "pep").should eql(["Pepsico"])
    end

    it "should return brands" do
      @current_account.products.distinct_brands(search: "pe").should eql(["Pepsi"])
    end

    it "should return sub brands" do
      @current_account.products.distinct_sub_brands(search: "mir").should eql(["Mirinda"])
    end

    it "should return functional names" do
      @current_account.products.distinct_functional_names(search: "soft d").should eql(["Soft drink"])
    end

    it "should return variants" do
      @current_account.products.distinct_variants(search: "li").should eql(["Light"])
    end

    it "should return tags" do
      @current_account.products.distinct_tags_names(search: "dr").should eql(["Drink"])
    end

    it "should have alias method for tags" do
      expected = @current_account.products.distinct_tags_names(search: "dr")
      @current_account.products.distinct_tags(search: "dr").should eql(expected)
    end

    it "should have alias method for functionals" do
      expected = @current_account.products.distinct_functionals(search: "soft d")
      @current_account.products.distinct_functional_names(search: "soft d").should eql(expected)
    end

    describe "other account data" do
      before do
        product = Fabricate(:product, manufacturer: "Pepper Computers", brand: "Miranda Global")
        product.tags.create(name: "Software")
      end

      it "should not include other product field data" do
        @current_account.products.distinct_manufacturers(search: "pep").should_not include("Pepper Computers")
      end

      it "should not include other product tags" do
        @current_account.products.distinct_tags_names(search: "soft").should_not include("Software")
      end
    end
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
