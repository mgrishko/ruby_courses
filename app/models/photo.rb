class Photo
  include Mongoid::Document
  field :image_tmp, type: String

  belongs_to :account, index: true
  belongs_to :product, index: true

  # CarrierWave
  mount_uploader :image, ImageUploader
  store_in_background :image

  # Really no point if we don't have an image so we always require one
  validates :image, presence: true, file_size: { maximum: 1.megabyte.to_i }
  validates :account, presence: true
  validates :product, presence: true

  attr_accessible :image

  before_validation :set_account

  private

  def set_account
    self.account = self.product.account unless product.blank?  # this *unless* condition is only to bypass shoulda test
  end
end