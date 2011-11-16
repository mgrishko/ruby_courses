require 'spec_helper'

describe "products/show.html.haml" do
  before(:each) do
    decorator = ProductDecorator.decorate(Fabricate.build(:product))
    @product = assign(:product, decorator)
    @product.stub(:edit_link)
    @product.stub(:destroy_link)
  end

  describe "content" do
    it "should not render body title" do
      render
      rendered.should_not have_selector(".content header #{Settings.page_title_header}")
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

    it "renders an edit link" do
      @product.should_receive(:edit_link).with(class: "btn large")
      render
    end

    it "renders a destroy link" do
      @product.should_receive(:destroy_link).with(class: "btn small danger")
      render
    end
  end
end
