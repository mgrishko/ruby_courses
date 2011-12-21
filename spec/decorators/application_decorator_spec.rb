require 'spec_helper'

describe ApplicationDecorator do
  before { ApplicationController.new.set_current_view_context }

  before(:each) do
    @product = Fabricate(:product, funcitional_name: "Product name", description: "Product description")
    @product_decorator = ProductDecorator.decorate(@product)
    @comment = Fabricate(:comment, commentable: @product, body: "smth written")
    @comment_decorator = CommentDecorator.decorate(@comment)
  end

  describe "#i18n_scope" do
    it "should point to model defaults" do
      ProductDecorator.i18n_scope.should == "products.defaults"
    end

    it "should prepend with namespace" do
      Admin::AccountDecorator.i18n_scope.should == "admin.accounts.defaults"
    end
  end

  describe "decorates" do
    describe "#show_link" do
      context "when user can view product" do
        it "renders link" do
          @product_decorator.h.stub(:can?).and_return(true)
          @product_decorator.show_link(name: :funcitional_name).
              should == "<a href=\"/products/#{@product.id}\">Product name</a>"
        end
      end

      context "when user cannot view product" do
        it "renders product name" do
          @product_decorator.h.stub(:can?).and_return(false)
          @product_decorator.show_link(name: :funcitional_name).should == "Product name"
        end
      end
    end

    describe "#edit_link" do
      context "when user can edit product" do
        it "renders link" do
          @product_decorator.h.stub(:can?).and_return(true)
          @product_decorator.edit_link.should == "<a href=\"/products/#{@product.id}/edit\">Edit Product</a>"
        end
      end

      context "when user cannot edit product" do
        it "should return empty string" do
          @product_decorator.h.stub(:can?).and_return(false)
          @product_decorator.edit_link.should be_blank
        end
      end
    end

    describe "#destroy_link" do
      context "when user can destroy product" do
        it "renders link" do
          @product_decorator.h.stub(:can?).and_return(true)
          @product_decorator.destroy_link(confirm: true).should ==
              "<a href=\"/products/#{@product.id
              }\" data-confirm=\"Are you sure?\" data-method=\"delete\" rel=\"nofollow\">Delete Product</a>"
        end
      end

      context "when user can destroy comment" do
        it "renders link" do
          @comment_decorator.h.stub(:can?).and_return(true)
          @comment_decorator.destroy_link(remote: true, through: @product).should ==
              "<a href=\"/products/#{@product.id}/comments/#{@comment.id
          }\" data-method=\"delete\" data-remote=\"true\" rel=\"nofollow\">Delete</a>"
        end
      end

      context "when user cannot destroy product" do
        it "should return empty string" do
          @product_decorator.h.stub(:can?).and_return(false)
          @product_decorator.destroy_link.should be_blank
        end
      end
    end

    describe "ClassDecorator#create_link" do
      context "when user can create product link" do
        it "renders product link" do
          @product_decorator.h.stub(:can?).and_return(true)
          ProductDecorator.create_link.should == "<a href=\"/products/new\">New Product</a>"
        end
      end

      context "when user can't create product link" do
        it "renders product link" do
          @product_decorator.h.stub(:can?).and_return(false)
          ProductDecorator.create_link.should be_blank
        end
      end
    end
  end
end
