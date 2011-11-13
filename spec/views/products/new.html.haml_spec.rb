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

    assert_select "form", :action => products_path, :method => "post" do
      assert_select "input#product_name", :name => "product[name]"
      assert_select "input#product_description", :name => "product[description]"
    end
  end
end
