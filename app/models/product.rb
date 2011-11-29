class Product
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String

  belongs_to :account
  embeds_many :comments, as: :commentable#, versioned: false

  validates :name, presence: true, length: 1..70
  validates :description, presence: true, length: 5..1000
  validates :account, presence: true

  attr_accessible :name, :description

  # Prepares comment for create and update actions
  def prepare_comment(user, attrs = {})
    comment = Comment.new(attrs)
    comment.user = user
    if comment.body.present? && comment.valid?
      self.comments << comment
    end
    comment
  end
end
