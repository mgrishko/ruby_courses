require 'spec_helper'

describe "products/new" do
  before(:each) do
    measurements = [
      stub_model(Measurement, name: "depth",        value: "", unit: "MM"),
      stub_model(Measurement, name: "gross_weight", value: "", unit: "GR"),
      stub_model(Measurement, name: "height",       value: "", unit: "MM"),
      stub_model(Measurement, name: "width",        value: "", unit: "MM"),
      stub_model(Measurement, name: "net_content",  value: "", unit: "ML"),
      stub_model(Measurement, name: "net_weight",   value: "", unit: "GR")
    ]
    # MM Millimetre, GR Gram, ML Millilitre

    product_codes = [stub_model(ProductCode, name: ProductCode::IDENTIFICATION_LIST.first, value: "")]

    assign(:product, ProductDecorator.decorate(stub_model(Product,
      :functional_name => "",
      :variant => "",
      :brand => "",
      :sub_brand => "",
      :manufacturer => "",
      :country_of_origin => "",
      :short_description => "",
      :description => "",
      :measurements => measurements,
      :gtin => "",
      :product_codes => product_codes,
      :tags_list => "",
      :visibility => "private"
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
      rendered.should have_field("product_functional_name", name: "product[functional_name]")
    end

    it "renders description field" do
      render
      rendered.should have_field("product_description", name: "product[description]")
    end

    #it "renders tags_list field" do
    #  render
    #  rendered.should have_field("product_tags_list", name: "product[tags_list]")
    #end

    #it "renders visibility field" do
    #  render
    #  rendered.should have_field("product_visibility", name: "product[visibility]")
    #end
  end

  describe "sidebar" do
    #it "renders a back link" do
    #  render
    #  view.content_for(:sidebar).should have_selector("a", text: "Back")
    #end
  end
end
