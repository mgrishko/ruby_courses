class User
  include Mongoid::Document

  field :first_name, type: String
  field :last_name, type: String
  field :time_zone, type: String
  field :locale, type: String, default: "en"

  has_and_belongs_to_many :accounts

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable, :recoverable, :lockable
  devise :database_authenticatable, :registerable, :trackable, :validatable, :rememberable

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :time_zone, presence: true
  validates :email, presence: true

  attr_accessible :email, :password, :first_name, :last_name, :time_zone, :locale
end
