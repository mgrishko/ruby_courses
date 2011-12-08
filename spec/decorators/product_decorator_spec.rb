require 'spec_helper'

describe ProductDecorator do
  before { ApplicationController.new.set_current_view_context }

  before(:each) do
    @product = Fabricate(:product,
                         name: "Product name",
                         manufacturer: "Manufacturer",
                         brand: "Brand",
                         description: "Product description",
                         visibility: "private"
    )
    @decorator = ProductDecorator.decorate(@product)
  end

  describe "allows" do
    it "#name" do
      @decorator.name.should == "Product name"
    end

    it "#manufacturer" do
      @decorator.manufacturer.should == "Manufacturer"
    end
    
    it "#brand" do
      @decorator.brand.should == "Brand"
    end

    it "#description" do
      @decorator.description.should == "Product description"
    end

    it "#created_at" do
      @decorator.created_at.should == @product.created_at
    end
    
    it "#updated_at" do
      @decorator.updated_at.should == @product.updated_at
    end
    
    it "#version" do
      @decorator.version.should == 1
    end
  end

  describe "#version_link" do
    context "when user can view product" do
      it "renders link" do
        @product.name = SecureRandom.hex(10)
        @product.save!
        @decorator.h.stub(:can?).and_return(true)
        @decorator.version_link(@product, @product).should == "Version 2"
        version = ProductDecorator.decorate(@product.versions.first)
        version.version_link(@product, @product).should ==
            "<a href=\"/products/#{@product.id}/versions/1\">Version 1</a>"
      end
    end

    context "when user cannot view product" do
      it "renders product name" do
        # ToDo FIX ME!!! Where is this test?
        #@decorator.h.stub(:can?).and_return(false)
        #@decorator.version_link(@product.versions.first, @product).should == "Version 1"
      end
    end
  end

  describe "#visibility_options" do
    it "returns options for select" do
      Product::VISIBILITIES = %w(private public)
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
end
