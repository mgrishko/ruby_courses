class Comment
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps

  field :body, type: String
  field :system, type: Boolean, default: false

  embedded_in :commentable, polymorphic: true
  belongs_to :user

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
  
  def self.super_find id, embedded_in
    embedded_in.comments.find(id)
  end
end
