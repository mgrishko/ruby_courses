require 'spec_helper'

describe "products/index.html.haml" do
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

  end

  describe "sidemenu" do
    it "renders a new link" do
      ProductDecorator.should_receive(:create_link)
      render
    end
  end
end
