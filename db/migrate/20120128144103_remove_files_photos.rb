class RemoveFilesPhotos < Mongoid::Migration
  def self.up
    Product.all.each do |product|
      product.photos.delete_all
    end
  end

  def self.down
  end
end