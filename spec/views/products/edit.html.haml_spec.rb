require 'spec_helper'

describe "products/edit.html.haml" do
  before(:each) do
    @product = assign(:product, stub_model(Product,
      :name => "",
      :description => ""
    ))
  end

  it "renders edit product form" do
    render
    rendered.should have_selector("form", action: edit_product_path(@product), method: "put")
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
