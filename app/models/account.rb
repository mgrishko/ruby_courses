class Account
  include Mongoid::Document

  field :subdomain, type: String
  field :company_name, type: String
  field :country, type: String
  field :time_zone, type: String
  field :locale, type: String, default: "en"

  has_and_belongs_to_many :users

  validates :subdomain, presence: true
  validates :company_name, presence: true
  validates :country, presence: true
  validates :time_zone, presence: true

  attr_accessible :subdomain, :company_name, :country, :time_zone, :locale

  state_machine :state, initial: :pending do
    event :activate do
      transition :pending => :active
    end
  end
end
