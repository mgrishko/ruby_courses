class Product
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Versioning
  include Mongoid::Taggable
  include Mongoid::Trackable
  include Mongoid::Search

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
  embeds_many :packages
  embeds_many :product_codes

  embeds_many :measurements # ToDo Remove after migration to packages
  
  def measurement(name)
    self.measurements.where(name: name.to_s).first
  end

  accepts_nested_attributes_for :packages
  attr_accessible :packages_attributes

  accepts_nested_attributes_for :product_codes
  attr_accessible :product_codes_attributes

  auto_complete_for :brand, :sub_brand, :variant, :functional_name, :manufacturer, :tags => :name

  filter_by :brand, :manufacturer, :tags => :name

  validates :functional_name, presence: true, length: 1..35
  validates :variant, length: 0..35
  validates :manufacturer, presence: true, length: 1..35
  validates :country_of_origin, presence: true, inclusion: { in: Carmen.country_codes }
  validates :brand, presence: true, length: 1..70
  validates :sub_brand, length: 0..70
  validates :short_description, length: 0..178
  validates :description, length: 0..1000
  validates :account, presence: true
  validates :visibility, presence: true, inclusion: { in: VISIBILITIES }
  validates :gtin, gtin_format: true

  before_validation :cleanup_product_codes

  # :version, :updated_at attributes required for Mongoid versioning support
  attr_accessible :functional_name, :variant, :gtin,
                  :short_description, :description, :version, :updated_at,
                  :brand, :sub_brand, :manufacturer, :country_of_origin, :visibility, :tags_list

  def self.distinct_tags(*args)
    self.distinct_tags_names(*args)
  end

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

  # ToDo We should remove this method from project by setting current user to model Thread safely
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
    comment = comments.last.present? && (Time.now - comments.last.created_at < 2.seconds) ?
        comments.last : comments.build
    comment.system = true
    comment.created_at = DateTime.now
    comment.user = user
    if comment.body.blank?
      comment.body = I18n.t("comments.defaults.product.#{new_record? ? "create" : "update"}")
    end
    save
  end

  private

  # Cleanups all product codes with blank values.
  def cleanup_product_codes
    self.product_codes.each do |m|
      m.destroy if m.value.blank?
    end
  end
end
