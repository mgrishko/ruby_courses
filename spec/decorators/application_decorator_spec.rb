require 'spec_helper'

describe ApplicationDecorator do
  before { ApplicationController.new.set_current_view_context }

  before(:each) do
    @product = Fabricate(:product, name: "Product name", description: "Product description")
    @decorator = ProductDecorator.decorate(@product)
  end

  describe "decorates" do
    describe "#show_link" do
      context "when user can view product" do
        it "renders link" do
          @decorator.h.stub(:can?).and_return(true)
          @decorator.show_link(name: :name, fallback: true).should =="<a href=\"/products/#{@product.id}\">Product name</a>"
        end
      end

      context "when user cannot view product" do
        it "renders product name" do
          @decorator.h.stub(:can?).and_return(false)
          @decorator.show_link(name: :name, fallback: true).should == "Product name"
        end
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
        it "should return empty string" do
          @decorator.h.stub(:can?).and_return(false)
          @decorator.edit_link.should be_blank
        end
      end
    end

    describe "#destroy_link" do
      context "when user can destroy product" do
        it "renders link" do
          @decorator.h.stub(:can?).and_return(true)
          @decorator.destroy_link.should ==
              "<a href=\"/products/#{@product.id
              }\" data-confirm=\"Are you sure?\" data-method=\"delete\" rel=\"nofollow\">Delete Product</a>"
        end
      end

      context "when user cannot destroy product" do
        it "should return empty string" do
          @decorator.h.stub(:can?).and_return(false)
          @decorator.destroy_link.should be_blank
        end
      end
    end
  end
end
