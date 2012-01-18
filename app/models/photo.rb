class Photo
  include Mongoid::Document
  embedded_in :product

  # CarrierWave
  mount_uploader :image, ImageUploader

  # Really no point if we don't have an image so we always require one
  validates_presence_of :image
  #validates :image, presence: true, file_size: { maximum: 1.megabyte.to_i }
end