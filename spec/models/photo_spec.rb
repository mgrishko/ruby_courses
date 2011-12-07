require 'spec_helper'

describe Photo do

  let(:photo) { Fabricate(:photo) }

  it { should validate_presence_of(:image) }

  it "should be embedded in product" do
    product = Fabricate(:product)
    photo = product.photos.build
    photo.product.should eql(product)
  end

  describe "uploader" do
    before(:each) do
      MiniMagick::Image.stub!(:open).and_return(100)

      @product = Fabricate(:product)
    end

    context "when file is not assigned" do
      it "should not save photo" do
        photo = @product.photos.build
        photo.save.should be_false
      end
    end

    context "when file is assigned" do
      # This should be enough to test that carrierwave is working
      it "should save photo file" do
        photo = @product.photos.build
        photo.image = MiniMagick::Image.new(File.join(Rails.root, '/spec/fabricators/image.jpg'))
        photo.save!
        photo.image.current_path.should ==
            (Rails.public_path + "/system/uploads/test/test/photo/#{photo.id}/image.jpg")
      end
    end
  end
end