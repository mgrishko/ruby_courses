class Membership
  include Mongoid::Document
  include Mongoid::Paranoia

  ROLES = %w(admin editor contributor viewer)

  field :role, type: String
  field :invitation_note, type: String

  embedded_in :account
  belongs_to :user, autosave: true
  accepts_nested_attributes_for :user
  attr_accessible :user

  belongs_to :invited_by, class_name: 'User'

  validates :user, presence: true, associated: true
  validates :role, presence: true, inclusion: { in: ROLES }
  validates :invitation_note, length: { maximum: 1000 }

  attr_accessible :role, :user, :invitation_note

  set_callback(:validation, :before) do |membership|
    membership.find_or_initialize_user if membership.new_record?
  end

  set_callback(:create, :after) do |membership|
    membership.send_membership_invitation unless membership.owner?
  end

  # Checks if membership has a role
  #
  # @param [String] role which should be checked
  # @return [Boolean] true if membership has role and false otherwise
  def role?(role)
    self.role == role.to_s
  end

  # Checks if current membership is an account owner
  #
  # if account present
  # @return [Boolean] true if membership is an account owner and false otherwise
  # otherwise return [nil]
  def owner?
    account.owner == self.user
    #!(self.new_record?) ? (account.owner == self.user) : nil
  end

  protected

  # It finds or creates user with given email.
  # Method is called by before validation callback.
  def find_or_initialize_user
    if self.user && self.user.new_record?
      existing_user = User.where(email: self.user.email).first

      if existing_user
        self.user = existing_user

        if self.account.memberships.any? { |m| m.user == existing_user && !(m == self)}
          self.errors.add(:already_invited, I18n.t("errors.messages.already_invited"))
        end
      else
        self.user.generate_password!
        self.user.locale = self.account.locale
        self.user.time_zone = self.account.time_zone
      end
    end
  end

  # It sends account membership invitation email.
  # It is called in after create callback.
  def send_membership_invitation
    MembershipMailer.invitation_email(self).deliver
  end
end
