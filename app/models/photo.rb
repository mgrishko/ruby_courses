class Photo
  include Mongoid::Document
  embedded_in :product

  # CarrierWave
  mount_uploader :image, ImageUploader

  # Really no point if we don't have an image so we always require one
  validates_presence_of :image
  
  def self.super_find id, embedded_in
    embedded_in.photos.find(id)
  end
end