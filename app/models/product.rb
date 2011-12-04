class Product
  include Trackable
  
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String

  belongs_to :account

  has_many :events, as: :trackable
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
  
  def build_updated_comment(user)
    comment = self.comments.build(body: I18n.t("products.defaults.updated_by", user_name: user.full_name), user: user)
    comment.system = true
    comment.save
    comment
  end
end
