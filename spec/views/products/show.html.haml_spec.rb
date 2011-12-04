require 'spec_helper'

describe "products/show.html.haml" do
  before(:each) do    
    product = Fabricate.build(:product_with_comments)
    decorator = ProductDecorator.decorate(product)
    @product = assign(:product, decorator)
    @product.stub(:edit_link)
    @product.stub(:destroy_link)
    
    ProductDecorator.any_instance.stub(:version_link).and_return("Version 1")
    ProductDecorator.any_instance.stub(:version_date).and_return("<span>Feb 04, 2001</span>".html_safe)
    
    @product_version = assign(:product_version, ProductDecorator.decorate(product))
    
    @comment = assign(:comment, stub_model(Comment,
      :commentable => product
    ).as_new_record)

    @comments = assign(:comments, CommentDecorator.decorate([stub_model(Comment,
      Fabricate.attributes_for(:comment, commentable: product, created_at: Time.now)
    )]))

    CommentDecorator.any_instance.stub(:destroy_link)
    view.stub(:can?).and_return(true)
  end

  describe "content" do
    it "should not render body title" do
      render
      rendered.should_not have_selector(".content header h1")
    end

    it "renders a product title" do
      render
      rendered.should have_selector("article header h2", text: @product.name)
    end

    it "renders a product description" do
      render
      rendered.should have_selector("article p", text: @product.description)
    end
  end

  describe "sidebar" do
    it "renders a product image" do
      render
      view.content_for(:sidebar).should have_selector("img")
    end

    it "renders a back link" do
      render
      view.content_for(:sidebar).should have_selector("a", text: "Back")
    end

    it "renders product versions header" do
      render
      view.content_for(:sidebar).should have_selector("h3", text: "Versions")
    end

    it "renders product version links with decorator" do
      render
      view.content_for(:sidebar).should have_selector("li", text: "Version 1")
    end

    it "renders product version dates with decorator" do
      render
      view.content_for(:sidebar).should have_selector("span", text: "Feb 04, 2001")
    end

    it "renders an edit link" do
      @product.should_receive(:edit_link).with(class: "btn large")
      render
    end
    
    it "renders a destroy link" do
      @product.should_receive(:destroy_link).with(class: "btn small danger")
      render
    end
  end

  describe "comments" do
    it "renders new comment form" do
      render
      rendered.should have_selector("form", action: product_comments_path(@product.id),
                                    method: "post", "data-remote" => true)
    end
  end
end
