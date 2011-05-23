class Image < ActiveRecord::Base
  
  def resize(data, width, height, scale, fill, name)
    image = data.clone
    original_width = image.columns.to_i
    original_height= image.rows.to_i
    image.strip!
    if scale
      if fill
	image.resize_to_fill!(width, height)
      else
	image.resize_to_fit!(width, height)
      end
    else
      if (original_height > height) or (original_width > width)
	if fill
	  image.resize_to_fill!(width, height)
	else
	  image.resize_to_fit!(width, height)
	end
      end
    end
    
    unless File.exist?("#{RAILS_ROOT}/public/data")
      Dir.mkdir("#{RAILS_ROOT}/public/data")
    end
    image.write("#{RAILS_ROOT}/public/data/#{self.id}#{name}.jpg")
  end

protected
  def before_destroy
    for image_parameter in IMAGE_PARAMETERS do
      if File.exist?("#{RAILS_ROOT}/public/#{self.id}#{image_parameter.name}.jpg")
	File.delete("#{RAILS_ROOT}/public/#{self.id}#{image_parameter.name}.jpg")
      end
    end
  end
end
