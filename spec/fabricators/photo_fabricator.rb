Fabricator(:photo) do
  image { MiniMagick::Image.new(File.join(Rails.root, '/spec/fabricators/image.jpg'))}
end