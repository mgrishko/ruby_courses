class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  #include Mongoid::Versioning

  field :name, type: String
  field :description, type: String

  belongs_to :account
  embeds_many :comments, as: :commentable#, versioned: false
  accepts_nested_attributes_for :comments, reject_if: proc { |c| c["body"].blank? }
  attr_accessible :comments

  validates :name, presence: true, length: 1..70
  validates :description, presence: true, length: 5..1000
  validates :account, presence: true

  attr_accessible :name, :description
end
