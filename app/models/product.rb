class Product
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Versioning
  include Mongoid::Taggable
  include Mongoid::Trackable
  include Mongoid::AutoComplete
  
  VISIBILITIES = %w(private public)

  field :functional_name  , type: String
  field :variant          , type: String
  field :manufacturer     , type: String
  field :country_of_origin, type: String
  field :brand            , type: String
  field :sub_brand        , type: String
  field :gtin             , type: String
  field :short_description, type: String
  field :description      , type: String
  field :visibility       , type: String, default: "public"
  field :updated_at       , versioned: true
  
  belongs_to :account

  embeds_many :comments, as: :commentable, versioned: false
  embeds_many :photos, versioned: false
  embeds_many :measurements
  embeds_many :product_codes

  accepts_nested_attributes_for :measurements, reject_if: lambda { self.value.blank? }
  attr_accessible :measurements_attributes

  accepts_nested_attributes_for :product_codes, reject_if: lambda { self.value.blank? }
  attr_accessible :product_codes_attributes

  auto_complete_for :brand, :manufacturer, :tags => :name

  validates :functional_name, presence: true, length: 1..35
  validates :variant, presence: true, length: 1..35
  validates :manufacturer, presence: true, length: 1..35
  validates :country_of_origin, presence: true, inclusion: { in: Carmen.country_codes }
  validates :brand, presence: true, length: 1..70
  validates :sub_brand, presence: true, length: 1..70
  validates :short_description, presence: true, length: 1..178
  validates :description, presence: true, length: 5..1000
  validates :account, presence: true
  validates :visibility, presence: true, inclusion: { in: VISIBILITIES }
  validates :gtin, presence: true, length: { is: 14 }, format: /\d{14}/

  # :version, :updated_at attributes required for Mongoid versioning support
  attr_accessible :functional_name, :variant, :gtin,
                  :short_description, :description, :version, :updated_at,
                  :brand, :sub_brand, :manufacturer, :country_of_origin, :visibility, :tags_list

  # @return [String] concatinated brand, sub brand, functional name and variant
  def name
    "#{brand} #{sub_brand} #{functional_name} #{variant}"
  end

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
end
