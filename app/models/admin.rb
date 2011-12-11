class Admin
  include Mongoid::Document

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable, :recoverable,
  devise :database_authenticatable, :trackable, :validatable, :rememberable, :lockable

  attr_accessible :email, :password
end
