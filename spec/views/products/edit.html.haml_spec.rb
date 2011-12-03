require 'spec_helper'

describe "products/edit.html.haml" do
  before(:each) do
    @product = assign(:product, ProductDecorator.decorate(stub_model(Product,
      :name => "",
      :description => ""
    )))

    assign(:comment, stub_model(Comment))
    assign(:photo, stub_model(Photo).as_new_record)
    PhotoDecorator.any_instance.stub(:destroy_link)

    view.stub(:can?).and_return(true)
  end

  describe "content" do
    it "renders edit product form" do
      render
      rendered.should have_selector("form", action: edit_product_path(@product), method: "get")
    end

    it "renders name field" do
      render
      rendered.should have_field("product_name", name: "product[name]")
    end

    it "renders description field" do
      render
      rendered.should have_field("product_description", name: "product[description]")
    end
  end

  describe "sidebar" do
    it "renders a back link" do
      render
      view.content_for(:sidebar).should have_selector("a", text: "Back")
    end
  end
end

