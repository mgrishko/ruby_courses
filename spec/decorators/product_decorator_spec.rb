require 'spec_helper'

describe ProductDecorator do
  before { ApplicationController.new.set_current_view_context }

  before(:each) do
    @product = Fabricate(:product, name: "Product name", description: "Product description")
    @decorator = ProductDecorator.decorate(@product)
  end

  describe "allows" do
    it "#name" do
      @decorator.name.should == "Product name"
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
end
