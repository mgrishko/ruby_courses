require 'spec_helper'

describe "products/new.html.haml" do
  before(:each) do
    assign(:product, ProductDecorator.decorate(stub_model(Product,
      :name => "",
      :description => "",
      :manufacturer => "",
      :brand => "",
      :tags_list => "",
      :visibility => ""
    ).as_new_record))

    ProductDecorator.stub(:visibility_options).and_return([["Private", "private"], ["Public", "public"]])

    assign(:comment, stub_model(Comment))
  end

  describe "content" do
    it "renders new product form" do
      render
      rendered.should have_selector("form", action: products_path, method: "post")
    end

    it "renders manufacturer field" do
      render
      rendered.should have_field("product_manufacturer", name: "product[manufacturer]")
    end

    it "renders brand field" do
      render
      rendered.should have_field("product_brand", name: "product[brand]")
    end

    it "renders name field" do
      render
      rendered.should have_field("product_name", name: "product[name]")
    end

    it "renders description field" do
      render
      rendered.should have_field("product_description", name: "product[description]")
    end

    it "renders tags_list field" do
      render
      rendered.should have_field("product_tags_list", name: "product[tags_list]")
    end

    it "renders visibility field" do
      render
      rendered.should have_field("product_visibility", name: "product[visibility]")
    end
  end

  describe "sidebar" do
    it "renders a back link" do
      render
      view.content_for(:sidebar).should have_selector("a", text: "Back")
    end
  end
end
