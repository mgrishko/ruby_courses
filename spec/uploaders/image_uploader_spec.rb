require 'spec_helper'
require 'carrierwave/test/matchers'

describe ImageUploader do
  #before do
  #  photo = Photo.new
  #
  #  ImageUploader.enable_processing = true
  #  @uploader = ImageUploader.new(photo, :image)
  #  @uploader.store!(File.open(File.join(Rails.root, '/spec/fabricators/image.jpg')))
  #end
  #
  #after do
  #  ImageUploader.enable_processing = false
  #end
  #
  #context 'the small version' do
  #  it "should scale down an image to fill within 75 by 75 pixels" do
  #    @uploader.small.should be_have_dimensions(75, 75)
  #  end
  #end
  #
  #context 'the medium version' do
  #  it "should scale down an image to limit within 200 by 200 pixels" do
  #    @uploader.medium.should be_no_larger_than(200, 200)
  #  end
  #end
  #
  #context 'the large version' do
  #  it "should scale down an image to limit within 700 by 700 pixels" do
  #    @uploader.large.should be_no_larger_than(700, 700)
  #  end
  #end

  #it "should make the image readable only to the owner and not executable" do
  #  @uploader.should have_premissions(0600)
  #end
end