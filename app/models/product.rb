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
  
  # Saves comment for product update.
  def create_updated_comment(user)
    comment = self.comments.build(body: I18n.t("products.events.update", user_name: user.full_name), user: user)
    comment.system = true
    comment.save
    comment
  end
  
  # Creates system comment or appends "Created/Updated by" text to comment body.
  #
  # @param [user] owner of the comment.
  # @return [Boolean] true if saved and false otherwise. 
  def save_with_system_comment(user)
    comment = comments.last || comments.build
    
    template = self.new_record? ? "products.events.create" : "products.events.update"
    system_comment_text = I18n.t(template, user_name: user.full_name)
    comment.system = true
    comment.created_at = DateTime.now
    comment.user = user
    comment.body = "#{comment.body}\r\n#{system_comment_text}"
    
    save
  end
end
