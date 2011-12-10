require 'spec_helper'

describe PhotoDecorator do
  before { ApplicationController.new.set_current_view_context }
  
  before(:each) do
    @photo = Fabricate(:photo)
    @decorator = PhotoDecorator.decorate(@photo)
  end
  
  it "#show_link" do
    @decorator.show_link(text: "text").should == "<a href=\"/products/#{@photo.product.id}##{@photo.id}\">text</a>"
  end
end
