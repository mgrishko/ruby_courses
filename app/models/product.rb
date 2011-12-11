class Product
  include Mongoid::Document

  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Versioning
  include Mongoid::Taggable
  include Mongoid::Trackable
  
  VISIBILITIES = %w(private public)

  field :name, type: String
  field :manufacturer, type: String
  field :brand, type: String
  field :description, type: String
  field :visibility, type: String, default: "public"
  field :updated_at, versioned: true
  
  belongs_to :account

  embeds_many :comments, as: :commentable, versioned: false
  embeds_many :photos, versioned: false

  validates :name, presence: true, length: 1..70
  validates :manufacturer, presence: true, length: 1..35
  validates :brand, presence: true, length: 1..70
  validates :description, presence: true, length: 5..1000
  validates :account, presence: true
  validates :visibility, presence: true, inclusion: { in: VISIBILITIES }

  # :version, :updated_at attributes required for Mongoid versioning support
  attr_accessible :name, :description, :version, :updated_at, :brand, :manufacturer, :visibility, :tags_list

  # @return [Boolean] true if visibility "public" and false otherwise.
  def public?
    visibility == "public"
  end

  # Prepares comment for create and update actions.
  def prepare_comment(user, attrs = {})
    comment = Comment.new(attrs)
    comment.created_at = Time.now
    comment.user = user
    if comment.body.present? && comment.valid?
      self.comments << comment
    end
    comment
  end
  
  # Saves product and creates system comment if needed. If the product
  # was created or updated less then 60 minutes ago no comment is created.
  #
  # @param [user] owner of the comment.
  # @return [Boolean] true if saved and false otherwise. 
  def save_with_system_comment(user)
    # If the most recent version was created/updated less then 60 minutes ago then
    # save without versioning.
    when_updated = versions.last.nil? ? updated_at : versions.last.updated_at
    if when_updated && when_updated >= (Time.now - Settings.events.collapse_timeframe.minutes)
      self.versionless { |p| return p.save }
    end
    
    # setup system comment
    comment = comments.last || comments.build
    comment.system = true
    comment.created_at = DateTime.now
    comment.user = user
    comment.body = "&nbsp;" if comment.body.nil? || comment.body.empty?
    save
  end
  
  # Finds a product by id or throws an exception. Used to find from a linked event.
  #
  # @param [id] product id.
  # @param [embedded_in] owner of the comment.
  # @return [Product] product.
  def self.super_find(id, embedded_in)
    find(id)
  end
end
