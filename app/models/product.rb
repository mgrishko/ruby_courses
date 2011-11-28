class Product
  include Mongoid::Document
  include Mongoid::Versioning
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :updated_at, versioned: true

  belongs_to :account

  validates :name, presence: true, length: 1..70
  validates :description, presence: true, length: 5..1000
  validates :account, presence: true

  attr_accessible :name, :description, :version, :updated_at
end
