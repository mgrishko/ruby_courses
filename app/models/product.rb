class Product
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Trackable
  
  field :name, type: String
  field :description, type: String
  has_many :events, as: :trackable
  belongs_to :account

  embeds_many :comments, as: :commentable, versioned: false
  embeds_many :photos, versioned: false

  validates :name, presence: true, length: 1..70
  validates :description, presence: true, length: 5..1000
  validates :account, presence: true

  attr_accessible :name, :description

  # Prepares comment for create and update actions
  def prepare_comment(user, attrs = {})
    comment = Comment.new(attrs)
    comment.created_at = Time.now
    comment.user = user
    if comment.body.present? && comment.valid?
      self.comments << comment
    end
    comment
  end
  
  # Saves comment for product update.
  def create_updated_comment(user)
    comment = self.comments.build(body: I18n.t("products.events.update", user_name: user.full_name), user: user)
    comment.system = true
    comment.save
    comment
  end
end
