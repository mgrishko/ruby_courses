class Account
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Trackable

  SUBDOMAIN_BLACKLIST = %w(admin api app beta blog community dashboard demo feedback fuck
    help login mail secured signin signup status support test www)

  field :subdomain, type: String
  field :company_name, type: String
  field :about_company, type: String
  field :country, type: String
  field :website, type: String
  field :time_zone, type: String
  field :locale, type: String, default: "en"

  ## Attr Normalization
  normalize_attribute :subdomain, :company_name, :website, :with => [:squish]
  
  belongs_to :owner, class_name: "User"
  embeds_many :memberships, validate: false
  has_many :products
  has_many :events

  index "memberships.user_id"

  before_validation :set_default_attributes, on: :create
  before_validation :downcase_subdomain

  validates :owner, presence: true
  validates :subdomain,
            presence: true,
            format: { with: /^[a-z0-9]+$/ },
            exclusion: { in: SUBDOMAIN_BLACKLIST },
            uniqueness: { case_sensitive: false },
            length: 3..32
  validates :company_name, presence: true, length: { maximum: 50 }
  validates :country, presence: true, inclusion: { in: Carmen.country_codes }
  validates :time_zone, presence: true, inclusion: { in: ActiveSupport::TimeZone.zones_map.keys }
  validates :website, length: 0..50
  validates :about_company, length: 0..250

  attr_accessible :subdomain, :company_name, :country, :time_zone, :locale,
    :website, :about_company

  state_machine :state, initial: :pending do
    event :activate do
      transition :pending => :active
    end
  end
  
  # @return [String] subdomain
  def name
    subdomain
  end

  private

  # Sets default time zone and locale from account owner.
  # Adds owner to memberships with admin role.
  def set_default_attributes
    if owner
      self.time_zone = owner.time_zone
      self.locale = owner.locale
      self.memberships.build user: owner, role: "admin" if self.memberships.empty?
    end
  end

  def downcase_subdomain
    self.subdomain.downcase! unless self.subdomain.blank?
  end
end
