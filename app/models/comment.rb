class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :body, type: String

  embedded_in :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true, length: { maximum: 1000 }
  validates :user, presence: true

  attr_accessible :body, :user
end
