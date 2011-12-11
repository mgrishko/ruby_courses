class Comment
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps

  field :body, type: String
  field :system, type: Boolean, default: false

  embedded_in :commentable, polymorphic: true
  belongs_to :user
  belongs_to :event

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
    c.event.nil?
  end
  
  # Finds a comment by id in a commentable object.
  # Used to find a comment from a linked event.
  # 
  # @param [id] comment id.
  # @param [commentable] owner of the comment.
  # @return [Comment] comment.
  def self.super_find(id, commentable)
    commentable.comments.find(id)
  end
end
