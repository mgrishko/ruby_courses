class ProductCode
  include Mongoid::Document

  IDENTIFICATION_LIST = %w(FOR_INTERNAL_USE_1)

  field :name, type: String
  field :value, type: String

  embedded_in :product

  validates :name, presence: true, inclusion: { in: IDENTIFICATION_LIST }
  validates :value, presence: true, length: 1..80

  attr_accessible :name, :value
end