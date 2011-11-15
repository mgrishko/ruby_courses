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

  describe "#edit_link" do
    context "when user can edit product" do
      it "renders link" do
        @decorator.h.stub(:can?).and_return(true)
        @decorator.edit_link.should == "<a href=\"/products/#{@product.id}/edit\">Edit Product</a>"
      end
    end

    context "when user cannot edit product" do
      it "should return empty string when user cannot edit product" do
        @decorator.h.stub(:can?).and_return(false)
        @decorator.edit_link.should be_blank
      end
    end
  end
end
