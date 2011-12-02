require 'spec_helper'

describe ApplicationDecorator do
  before { ApplicationController.new.set_current_view_context }
  
  before(:each) do
    @product = Fabricate(:product, name: "Product name", description: "Product description")
    @decorator = ApplicationDecorator.decorate(@product)
  end

  describe "#format_date" do
    it "renders formatted date" do
      @decorator.format_date(Date.parse('2001-02-03')).should == "Feb 03, 2001"
    end
  end
end
