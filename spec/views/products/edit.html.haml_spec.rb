require 'spec_helper'

describe "products/edit" do
  before(:each) do
    product_codes = [stub_model(ProductCode, name: ProductCode::IDENTIFICATION_LIST.first, value: "")]

    @product = assign(:product, ProductDecorator.decorate(stub_model(Product,
      :functional_name => "",
      :variant => "",
      :brand => "",
      :sub_brand => "",
      :manufacturer => "",
      :country_of_origin => "",
      :short_description => "",
      :description => "",
      :gtin => "",
      :product_codes => product_codes,
      :tags_list => "",
      :visibility => "private"
    )))

    @product.stub(:destroy_link)

    ProductDecorator.stub(:visibility_options).and_return([["Private", "private"], ["Public", "public"]])

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
      rendered.should have_field("product_functional_name", name: "product[functional_name]")
    end

    it "renders manufacturer field" do
      render
      rendered.should have_field("product_manufacturer", name: "product[manufacturer]")
    end

    it "renders brand field" do
      render
      rendered.should have_field("product_brand", name: "product[brand]")
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

  describe "sidemenu" do
    it "renders a destroy link" do
      @product.should_receive(:destroy_link).with(confirm: true)
      render
    end
  end
end

