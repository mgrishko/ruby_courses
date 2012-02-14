require 'spec_helper'

describe Photo do

  let(:photo) { Fabricate(:photo) }

  it { should validate_presence_of(:image) }
  it { should validate_presence_of(:account) }
  it { should_not allow_mass_assignment_of(:account) }
  it { should validate_presence_of(:product) }
  it { should_not allow_mass_assignment_of(:product) }

  it "should belong to product" do
    product = Fabricate(:product)
    photo = product.photos.build
    photo.product.should eql(product)
  end

  it "should belong to account" do
    account = Fabricate(:account)
    photo = account.photos.build
    photo.account.should eql(account)
  end

  it "should set account before validation" do
    product = Fabricate(:product)
    photo = product.photos.new
    photo.valid?
    photo.account.should eql(product.account)
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
      it "should store in background by default" do
        photo = @product.photos.build
        photo.image = MiniMagick::Image.new(File.join(Rails.root, '/spec/fabricators/image.jpg'))
        photo.save!
        photo.image.current_path.should == (Rails.public_path + "/uploads/tmp/#{photo.image_tmp}")
      end

      it "should process image upload immediately" do
        photo = @product.photos.build
        photo.image = MiniMagick::Image.new(File.join(Rails.root, '/spec/fabricators/image.jpg'))
        photo.process_image_upload = true
        photo.save!
        photo.image.current_path.should ==
            (Rails.public_path + "/system/uploads/test/test/photo/#{photo.id}/image.jpg")
      end
    end
    
    context "when file is not an image" do
      it "should not save photo file" do
        @product = Fabricate(:product)
        photo = @product.photos.build
        photo.image = MiniMagick::Image.new(File.join(Rails.root, '/spec/fabricators/image.txt'))
        photo.save.should be_false
      end
    end
    
    context "when file is too big" do
      it "should not save photo file" do
        @product = Fabricate(:product)
        photo = @product.photos.build
        photo.image = MiniMagick::Image.new(File.join(Rails.root, '/spec/fabricators/image.jpg'))
        photo.image.stub(:size).and_return(2 * 1024 * 1024)
        photo.save.should be_false
      end
    end
  end
end