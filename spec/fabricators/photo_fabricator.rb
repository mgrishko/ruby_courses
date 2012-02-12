Fabricator(:photo) do
  product!
  image { MiniMagick::Image.new(File.join(Rails.root, '/spec/fabricators/image.jpg'))}

  after_build do |photo|
    photo.process_image_upload = true
  end
end