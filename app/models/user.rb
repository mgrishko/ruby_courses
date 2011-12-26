class User
  include Mongoid::Document

  field :first_name, type: String
  field :last_name, type: String
  field :time_zone, type: String
  field :locale, type: String, default: "en"

  has_many :accounts, foreign_key: :owner_id, autosave: true
  has_many :events
  accepts_nested_attributes_for :accounts
  attr_accessible :accounts_attributes

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable, :recoverable, :lockable
  devise :database_authenticatable, :registerable, :trackable, :validatable, :rememberable

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :time_zone, presence: true, inclusion: { in: ActiveSupport::TimeZone.zones_map.keys }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 50 }
  validates :password, presence: true, if: :password_required?

  attr_accessible :email, :password, :first_name, :last_name, :time_zone, :locale

  # @return [String] user full name
  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  # @return [String] user short name
  def short_name
    "#{self.first_name} #{self.last_name[0]}."
  end

  def generate_password!
    array = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    self.password = 8.times.map{ array[Random.rand(array.length - 1)] }.join

    Rails.logger.debug self.password
    generate_password! unless /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/.match(self.password)
  end
end
