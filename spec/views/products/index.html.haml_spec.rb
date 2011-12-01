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

    ProductDecorator.any_instance.stub(:create_link)
    Product.any_instance.stub(:show_link)
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
  end

  describe "sidebar" do
    it "renders a new link" do
      view.should_receive(:create_link).with(class: "btn large primary")
      render
    end
  end
end
