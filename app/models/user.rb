class User
  include Mongoid::Document

  field :first_name, type: String
  field :last_name, type: String
  field :time_zone, type: String
  field :locale, type: String, default: "en"

  has_many :accounts, foreign_key: :owner_id, autosave: true
  accepts_nested_attributes_for :accounts
  attr_accessible :accounts_attributes

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable, :recoverable, :lockable
  devise :database_authenticatable, :registerable, :trackable, :validatable, :rememberable

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :time_zone, presence: true, inclusion: { in: ActiveSupport::TimeZone.zones_map.keys }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 50 }
  validates :password, length: 5..20, if: :password_required?

  attr_accessible :email, :password, :first_name, :last_name, :time_zone, :locale

  #private
  #def password_required?
    #!persisted? || !password.nil? || !password_confirmation.nil?
  #end
end
