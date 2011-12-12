class Photo
  include Mongoid::Document
  embedded_in :product

  # CarrierWave
  mount_uploader :image, ImageUploader

  # Really no point if we don't have an image so we always require one
  validates_presence_of :image
  
  # Finds a photo in product by id. Used to find a photo from a linked event.
  # 
  # @param [id] photo id.
  # @param [product] product in which the photo is embedded.
  # @return [Photo] photo if found or nil otherwise.
  def self.find_by_id_and_embedded_in(id, product)
    product.photos.where("_id" => id).first
  end
end