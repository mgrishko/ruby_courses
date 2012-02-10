class User
  include Mongoid::Document

  field :first_name, type: String
  field :last_name, type: String
  field :time_zone, type: String
  field :locale, type: String, default: "en"

  # Devise fields
  ## Database authenticatable
  field :email,              :type => String, :null => false
  field :encrypted_password, :type => String, :null => false

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Attr Normalization
  normalize_attribute :first_name, :last_name, :with => [:squish]
  
  ## Encryptable
  # field :password_salt, :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  # Token authenticatable
  # field :authentication_token, :type => String

  has_many :accounts, foreign_key: :owner_id, autosave: true
  has_many :events
  accepts_nested_attributes_for :accounts
  attr_accessible :accounts_attributes

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable, :lockable
  devise :database_authenticatable, :registerable, :trackable, :validatable, :rememberable, :recoverable

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :time_zone, presence: true, inclusion: { in: ActiveSupport::TimeZone.zones_map.keys }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 50 }

  attr_accessible :email, :password, :first_name, :last_name, :time_zone, :locale

  # @return [String] user full name
  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  # @return [String] user short name
  def short_name
    "#{self.first_name} #{self.last_name[0]}."
  end

  # @return [Array] user memberships
  def memberships
    Account.where(:"memberships.user_id" => self.id).all.map do |account|
      account.memberships.select{ |membership| membership.user_id == self.id }.first
    end
  end

  def generate_password!
    array = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    self.password = 8.times.map{ array[Random.rand(array.length - 1)] }.join

    Rails.logger.debug self.password
    generate_password! unless /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/.match(self.password)
  end
end
