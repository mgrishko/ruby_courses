class Account
  include Mongoid::Document

  field :subdomain, type: String
  field :company_name, type: String
  field :country, type: String
  field :time_zone, type: String
  field :locale, type: String, default: "en"

  has_and_belongs_to_many :users

  before_validation :set_default_attributes, on: :create
  before_validation :downcase_subdomain

  validates :subdomain,
            presence: true,
            format: { with: /^[a-z0-9]+$/ },
            exclusion: { in: %w(www app admin dashboard secured) }
  validates :company_name, presence: true
  validates :country, presence: true
  validates :time_zone, presence: true

  attr_accessible :subdomain, :company_name, :country, :time_zone, :locale

  state_machine :state, initial: :pending do
    event :activate do
      transition :pending => :active
    end
  end

  private

  def set_default_attributes
    # When account is creating user (who signs up account) should have been already persisted.
    user = self.users.first
    unless user.nil?
      self.time_zone = user.time_zone
      self.locale = user.locale
    end
  end

  def downcase_subdomain
    self.subdomain.downcase! unless self.subdomain.blank?
  end
end
