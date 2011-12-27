require 'spec_helper'

describe PhotoDecorator do
  before { ApplicationController.new.set_current_view_context }
  
  before(:each) do
    @photo = Fabricate(:photo)
    @decorator = PhotoDecorator.decorate(@photo)
  end
end
