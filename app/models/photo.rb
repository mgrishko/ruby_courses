class Photo
  include Mongoid::Document
  field :image_tmp, type: String

  belongs_to :account, index: true
  belongs_to :product, index: true

  # CarrierWave
  mount_uploader :image, ImageUploader
  #store_in_background :image

  # Really no point if we don't have an image so we always require one
  validates :image, presence: true, file_size: { maximum: 1.megabyte.to_i }
  validates :product, presence: true

  attr_accessible :image

  before_create :set_account

  private

  # Caches account_id in photo to easily get all account photos.
  def set_account
    self.account_id = self.product.account_id
  end
end