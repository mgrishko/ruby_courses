require 'spec_helper'

describe "products/index" do
  before(:each) do
    @products = assign(:products, ProductDecorator.decorate([
      stub_model(Product,
        :short_description => "Short Description",
        :description => "Description",
        :manufacturer => "Manufacturer",
        :country_of_origin => "US",
        :brand => "Brand",
        :sub_brand => "Sub Brand"
      ),
      stub_model(Product,
        :short_description => "Short Description",
        :description => "Description",
        :manufacturer => "Manufacturer",
        :country_of_origin => "US",
        :brand => "Brand",
        :sub_brand => "Sub Brand"
      )
    ]))

    ProductDecorator.stub(:create_link)
    ProductDecorator.any_instance.stub(:show_link)

    Product.any_instance.stub(:visibility_label).with(public: false).
        and_return("<span class='label important'>Private</span>".html_safe)
    Product.any_instance.stub(:tag_labels).
        and_return("<span class='label'>Tag 1</span>".html_safe)

    ProductDecorator.stub(:submenu_header_link)
    ProductDecorator.stub(:filter_options).and_return([])
  end

  describe "sidemenu" do
    it "renders a new link" do
      ProductDecorator.should_receive(:create_link)
      render
    end

    it "renders a brand filter" do
      ProductDecorator.should_receive(:submenu_header_link).with(:brand)
      render
    end

    it "renders a manufacturer filter" do
      ProductDecorator.should_receive(:submenu_header_link).with(:manufacturer)
      render
    end

    it "renders a functional filter" do
      ProductDecorator.should_receive(:submenu_header_link).with(:functional)
      render
    end

    #it "renders a tag filter" do
    #  ProductDecorator.should_receive(:submenu_header_link).with(:tag)
    #  render
    #end
  end

  describe "submenu" do
    it "renders a brand filter options" do
      ProductDecorator.should_receive(:filter_options).with(:brand)
      render
    end

    it "renders a manufacturer filter options" do
      ProductDecorator.should_receive(:filter_options).with(:manufacturer)
      render
    end

    it "renders a functional filter options" do
      ProductDecorator.should_receive(:filter_options).with(:functional)
      render
    end

    #it "renders a tag filter options" do
    #  ProductDecorator.should_receive(:filter_options).with(:tag)
    #  render
    #end
  end
end
