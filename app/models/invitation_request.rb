class InvitationRequest < ActiveRecord::Base
  include AASM
  aasm_column :status
  aasm_state :new
  aasm_state :declined
  aasm_state :invited

  aasm_initial_state :new
    
  aasm_event :invite do
    transitions :from => :new, :to => :invited
  end

  aasm_event :decline do
    transitions  :from => :new, :to => :declined
  end
  
  validates :email, 
            :presence => true, 
            :uniqueness => true,
            :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :name, 
            :presence => true, 
            :length => { :within => 1..50 }
  validates :company_name, 
            :presence => true, 
            :length => { :within => 1..50 }
  validates :notes,
            :length => { :within => 1..140 }
            
  ROLES = %w[retailer local_supplier global_supplier]
  
  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum if roles
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end
end

# == Schema Information
#
# Table name: invitation_requests
#
#  id           :integer         not null, primary key
#  email        :string(255)
#  name         :string(255)
#  company_name :string(255)
#  notes        :text
#  status       :string(255)
#  roles_mask   :integer
#  created_at   :datetime
#  updated_at   :datetime
#

