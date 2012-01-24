require 'spec_helper'

describe PhotoObserver do
  it "should create new event on photo creation" do
    photo = mock_model(Photo)
    photo.stub_chain(:product, :log_event).and_return(true)
    photo.stub(:log_event).and_return(true)
    
    observer = PhotoObserver.instance
    photo.product.should_receive(:log_event).with("create", photo)
    observer.after_create(photo)
  end
end
