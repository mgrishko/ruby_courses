require 'spec_helper'

describe ProductDecorator do
  before { ApplicationController.new.set_current_view_context }

  before(:each) do
    @product = Fabricate(:product,
                         functional_name: "Product name",
                         manufacturer: "Manufacturer",
                         brand: "Brand",
                         sub_brand: "Sub Brand",
                         variant: "Variant",
                         country_of_origin: "US",
                         description: "Product description",
                         visibility: "private"
    )
    @decorator = ProductDecorator.decorate(@product)
  end

  describe "#version_link" do
    before(:each) do
      @product.functional_name = SecureRandom.hex(10)
      @product.save!
      @version = ProductDecorator.decorate(@product.versions.first)
    end

    it "renders link to other versions" do
      @decorator.h.stub(:can?).and_return(true)
      @version.version_link(@product, @product).should ==
          "<a href=\"/products/#{@product.id}/versions/1\">Version 1</a>"
    end

    it "should not render link to current version" do
      @decorator.h.stub(:can?).and_return(true)
      @decorator.version_link(@product, @product).should == "Version 2"
    end
  end

  describe "#visibility_options" do
    it "returns options for select" do
      ProductDecorator.visibility_options.should == [["Private", "private"], ["Public", "public"]]
    end
  end

  describe "#visibility_label" do
    context "when product is private" do
      before(:each) do
        @product.stub(:public?).and_return(false)
      end

      it "renders label" do
        @decorator.visibility_label.should == "<span class=\"label important\">Private</span>"
      end

      it "renders label with wrapper option" do
        @decorator.visibility_label(wrapper: :div).should ==
            "<div><span class=\"label important\">Private</span></div>"
      end

      it "renders label with public false option" do
        @decorator.visibility_label(public: false).should ==
            "<span class=\"label important\">Private</span>"
      end
    end

    context "when product is public" do
      before(:each) do
        @product.visibility = "public"
        @decorator = ProductDecorator.decorate(@product)
        @product.stub(:public?).and_return(true)
      end

      it "renders label" do
        @decorator.visibility_label.should == "<span class=\"label success\">Public</span>"
      end

      context "when user cannot view product" do
        it "renders product name" do
          @decorator.h.stub(:can?).and_return(false)
          @decorator.show_link(name: :name).should == @product.name
        end

        it "renders label with wrapper option" do
          @decorator.visibility_label(wrapper: :div).should ==
              "<div><span class=\"label success\">Public</span></div>"
        end
      end

      it "does not render label with public false option" do
        @decorator.visibility_label(wrapper: :li, public: false).should == ""
      end
    end
  end

  describe "#submenu_header_link" do
    it "renders menu link" do
      ProductDecorator.submenu_header_link(:brand).should == "<a href=\"#\" data-submenu=\"brand\">Brands</a>"
    end
  end
  
  describe "#filter_options" do
    it "returns options for brand" do
      ProductDecorator.filter_options(:brand).should == (["Brand"])
    end
    
    it "returns options for manufacturer" do
      ProductDecorator.filter_options(:manufacturer).should == (["Manufacturer"])
    end
  end

  describe "#tag_labels" do
    before(:each) do
      @product.stub(:tags).and_return([
        stub_model(Tag, name: "Tag1"),
        stub_model(Tag, name: "Tag2")
      ])
    end

    it "renders label" do
      @decorator.tag_labels.should == "<span class=\"label\">Tag1</span><span class=\"label\">Tag2</span>"
    end

    it "renders label with wrapper option" do
      @decorator.tag_labels(wrapper: :li).should ==
          "<li><span class=\"label\">Tag1</span></li><li><span class=\"label\">Tag2</span></li>"
    end
  end

  describe "#setup_nested" do
    before(:each) do
      @product = Product.new
      @decorator = ProductDecorator.decorate(@product)
    end

    it "returns product" do
      decorator = @decorator.setup_nested
      decorator.should eql(@product)
    end

    context "packages" do
      it "builds package" do
        @decorator.packages.should be_empty
        @decorator.setup_nested
        @decorator.packages.length.should == 1
      end

      it "doesn't build package if it already exists" do
        package = @product.packages.build
        @decorator.setup_nested
        @decorator.packages.should include(package)
        @decorator.packages.length.should == 1
      end

      describe "measurements" do
        before(:each) do
          @decorator.setup_nested
          @package = @decorator.packages.first
        end

        it "builds dimension" do
          @package.dimensions.length.should == 1
        end

        it "builds weight" do
          @package.weights.length.should == 1
        end

        it "builds content" do
          @package.contents.length.should == 1
        end
      end
    end

    context "product codes" do
      before(:each) do
        @code_name = ProductCode::IDENTIFICATION_LIST.first
      end

      it "builds new identification" do
        @decorator.setup_nested
        @decorator.product_codes.map(&:name).should include(@code_name)
      end

      it "doesn't build identification if it already exists" do
        product_code = @product.product_codes.build name: @code_name, value: "A0001"
        @decorator.setup_nested
        @decorator.product_codes.should include(product_code)
        @decorator.product_codes.length.should == 1
      end
    end
  end

  describe "#unit_options" do
    it "returns options for dimension" do
      measurement = Fabricate.build(:dimension)
      ProductDecorator.unit_options(measurement).should == [["mm", "MM"]]
    end

    it "returns options for net content" do
      measurement = Fabricate.build(:content)
      ProductDecorator.unit_options(measurement).sort.should == [["ml", "ML"], ["mm", "MM"], ["g", "GR"]].sort
    end
  end
  
  describe "#type_options" do
    it "returns packaging type options" do
      ProductDecorator.type_options.should_not be_empty
    end
  end
  
  describe "#measure_value_label" do
    it "returns measurement name with unit by default" do
      measurement = Fabricate.build(:dimension, unit: "MM")
      ProductDecorator.measure_value_label(measurement, :height).should == "Height, mm"
    end

    it "returns measurement name without unit" do
      measurement = Fabricate.build(:content, unit: "ML")
      ProductDecorator.measure_value_label(measurement, :value, show_unit: false).should == "Net content"
    end
  end

  describe "#trackable_link" do
    context "when user can view product" do
      it "should equal to #show_link" do
        @decorator.h.stub(:can?).and_return(true)
        @decorator.trackable_link.should == @decorator.show_link
      end
    end

    context "when user cannot view product" do
      it "should equal to #show_link" do
        @decorator.h.stub(:can?).and_return(false)
        @decorator.trackable_link.should == @decorator.show_link
      end
    end
  end

  describe "#country_of_origin" do
    it "should return country name" do
      @decorator.country_of_origin.should == "United States"
    end
  end

  describe "#title" do
    context "when net content presents" do
      before(:each) do
        @package = @product.packages.build
        @package.contents.new Fabricate.attributes_for(:content, value: 300, unit: "ML")
      end

      it "should concat brand, sub brand, variant and net content" do
        decorator = ProductDecorator.decorate(@product)
        decorator.title.should == "Brand Sub Brand Variant, 300 ml"
      end

      it "should strip parts" do
        @product.sub_brand = "  Sub Brand  "
        @product.variant = "  Variant  "
        decorator = ProductDecorator.decorate(@product)
        decorator.title.should == "Brand Sub Brand Variant, 300 ml"
      end
    end

    context "when net content and sub brand do not present" do
      it "should concat brand and variant" do
        @product.sub_brand = nil
        decorator = ProductDecorator.decorate(@product)
        decorator.title.should == "Brand Variant"
      end
    end
  end

  describe "#item_label" do
    it "should concat manufacturer and country of origin" do
      @decorator.item_label.should == "Manufacturer, United States"
    end
  end

  describe "#group" do
    before(:each) do
      @product1 = Fabricate(:product, functional_name: "functional 1", brand: "Brand")
      @product2 = Fabricate(:product, functional_name: "functional 2", brand: "Brand")
      @products = ProductDecorator.decorate([@product1, @product2])
    end

    it "should group products by functional name" do
      expected = { "functional 1" => [@product1], "functional 2" => [@product2] }
      ProductDecorator.group(@products, by: :functional_name).should == expected
    end

    it "should group products by brand" do
      expected = { "Brand" => [@product1, @product2] }
      ProductDecorator.group(@products, by: :brand).should == expected
    end
  end

  context "measurements" do
    before(:each) do
      @package = @product.packages.build
    end

    describe "#dimension" do
      context "when exists" do
        it "should return value with unit" do
          @package.dimensions.new Fabricate.attributes_for(:dimension, height: 300, unit: "MM")
          decorator = ProductDecorator.decorate(@product)
          decorator.dimension(:height).should == "300 mm"
        end
      end

      context "when does not exist" do
        it "should be blank" do
          @decorator.dimension(:height).should be_blank
        end
      end
    end
    
    describe "#packaging_type" do
      context "when exists" do
        it "should return value" do
          @package.type = "AE"
          decorator = ProductDecorator.decorate(@product)
          decorator.packaging_type.should == "Aerosol"
        end
      end

      context "when does not exist" do
        it "should be blank" do
          @decorator.packaging_type.should be_blank
        end
      end
    end

    describe "#weight" do
      context "when exists" do
        it "should return value with unit" do
          @package.weights.new Fabricate.attributes_for(:weight, gross: 300, unit: "GR")
          decorator = ProductDecorator.decorate(@product)
          decorator.weight(:gross).should == "300 g"
        end
      end

      context "when does not exist" do
        it "should be blank" do
          @decorator.weight(:gross).should be_blank
        end
      end
    end

    describe "#content" do
      context "when exists" do
        it "should return value with unit" do
          @package.contents.new Fabricate.attributes_for(:content, value: 300, unit: "ML")
          decorator = ProductDecorator.decorate(@product)
          decorator.content(:value).should == "300 ml"
        end
      end

      context "when does not exist" do
        it "should be blank" do
          @decorator.content(:value).should be_blank
        end
      end
    end
  end
end
