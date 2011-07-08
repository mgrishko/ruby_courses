# == Schema Information
#
# Table name: images
#
#  id           :integer(4)      not null, primary key
#  item_id      :integer(4)      not null
#  created_at   :datetime
#  updated_at   :datetime
#  base_item_id :integer(4)
#

class Image < ActiveRecord::Base

  has_one :event, :as => :content, :dependent => :destroy
  belongs_to :base_item
  before_destroy :delete_file
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

  def get_url(current_user)
    if current_user.retailer?
      "/base_items/#{self.base_item_id}?view=true"
    else
      "/base_items/#{self.base_item_id}"
    end
  end

  def get_title
  end

  def get_description
    self.base_item.item_description.to_s
  end

protected
  def delete_file
    for image_parameter in IMAGE_PARAMETERS do
      if File.exist?("#{RAILS_ROOT}/public/#{self.id}#{image_parameter.name}.jpg")
	File.delete("#{RAILS_ROOT}/public/#{self.id}#{image_parameter.name}.jpg")
      end
    end
  end
end

