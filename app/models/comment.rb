class Comment
  include Trackable
  
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps

  field :body, type: String
  field :system, type: Boolean, default: false

  embedded_in :commentable, polymorphic: true
  belongs_to :user
  has_many :events, as: :trackable

  validates :body, presence: true, length: { maximum: 1000 }
  validates :user, presence: true

  attr_accessible :body, :user

  # In some situations Mongoid does not set timestamps even if there are not present. So it's a monkey patch.
  set_callback(:save, :before) do |comment|
    t = Time.now
    comment.created_at = t if comment.new_record?
    comment.updated_at = t
  end
  
  # System comments can't be destroyed
  set_callback(:destroy, :before) do |c|
    !c.system?
  end
  
  # Finds comment by id. Performs search in deleted and present products and comments.
  def self.find_trackable(trackable_id)
    product = Product.unscoped.where(:"comments._id" => trackable_id).first
    product.comments.unscoped.find(trackable_id)
  end
end
