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
  end

  describe "#create_link" do
    context "when user can create product link" do
      it "renders product link" do
        @decorator.h.stub(:can?).and_return(true)
        ProductDecorator.create_link.should == "<a href=\"/products/new\">New Product</a>"
      end
    end

    context "when user can't create product link" do
      it "renders product link" do
        @decorator.h.stub(:can?).and_return(false)
        ProductDecorator.create_link.should be_blank
      end
    end
  end
end
