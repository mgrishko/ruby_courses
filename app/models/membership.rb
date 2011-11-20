class Membership
  include Mongoid::Document

  ROLES = %w(admin editor contributor viewer)

  field :role, type: String

  embedded_in :account
  belongs_to :user

  validates :user, presence: true
  validates :role, presence: true, inclusion: { in: ROLES }

  attr_accessible :role, :user

  def role?(role)
    self.role == role.to_s
  end

  def owner?
    self.user == self.account.owner
  end

end
