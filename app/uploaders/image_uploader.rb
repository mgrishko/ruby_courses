# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    env = Rails.env.test? || Rails.env.cucumber? ? "test/#{Rails.env}/" : ""
    "uploads/#{env}/#{model.class.to_s.underscore}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :large do
    process :resize_to_limit => [700, 700]
    process :strip
  end

  version :medium do
    process :resize_to_limit => [200, 200]
    process :strip
  end

  version :small do
    process :resize_to_fill => [75, 75]
    process :strip
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
     %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  # Strips photo EXIF data. It saves ~ 25kB on every single image version.
  def strip
    manipulate! do |img|
      img.strip
      img = yield(img) if block_given?
      img
    end
  end
end
