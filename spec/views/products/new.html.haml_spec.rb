require 'spec_helper'

describe "products/new.html.haml" do
  before(:each) do
    assign(:product, stub_model(Product,
      :name => "",
      :description => ""
    ).as_new_record)
  end

  it "renders new product form" do
    render
    rendered.should have_selector("form", action: products_path, method: "post")
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
