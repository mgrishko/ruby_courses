class Photo
  include Mongoid::Document
  #embedded_in :product
  belongs_to :product
  field :image_tmp, type: String

  # CarrierWave
  mount_uploader :image, ImageUploader
  store_in_background :image

  # Really no point if we don't have an image so we always require one
  validates_presence_of :image
  validates :image, file_size: { maximum: 1.megabyte.to_i }
end