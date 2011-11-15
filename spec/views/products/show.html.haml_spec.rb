require 'spec_helper'

describe "products/show.html.haml" do
  stub_ability

  before(:each) do
    decorator = ProductDecorator.decorate(Fabricate.build(:product))
    @product = assign(:product, decorator)
    @product.stub(:edit_link)
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
  end
end
