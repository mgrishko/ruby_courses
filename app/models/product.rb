class Product
  include Mongoid::Document
  include Mongoid::Versioning

  field :name, type: String
  field :description, type: String

  belongs_to :account

  validates :name, presence: true, length: 1..70
  validates :description, presence: true, length: 5..1000
  validates :account, presence: true

  #attr_accessible :name, :description, :version
end
