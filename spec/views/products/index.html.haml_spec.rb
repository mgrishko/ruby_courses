require 'spec_helper'

describe "products/index.html.haml" do
  before(:each) do
    @products = assign(:products, [
      stub_model(Product,
        :name => "",
        :description => ""
      ),
      stub_model(Product,
        :name => "",
        :description => ""
      )
    ])

    ProductDecorator.stub(:create_link)
    Product.any_instance.stub(:show_link)

    Product.any_instance.stub(:visibility_label).with(public: false).
        and_return("<span class='label important'>Private</span>".html_safe)
    Product.any_instance.stub(:tag_labels).
        and_return("<span class='label'>Tag 1</span>".html_safe)
  end

  describe "content" do
    it "renders a list of products" do
      render
      rendered.should have_selector("table tr", count: 2)
    end

    it "renders product show link" do
      @products.each do |product|
        product.should_receive(:show_link)
      end
      render
    end

    it "renders product visibility" do
      render
      rendered.should have_selector("span.important", text: "Private")
    end

    it "renders product tags" do
      render
      rendered.should have_selector("span.label", text: "Tag 1")
    end
  end

  describe "sidemenu" do
    it "renders a new link" do
      ProductDecorator.should_receive(:create_link)
      render
    end
  end
end
