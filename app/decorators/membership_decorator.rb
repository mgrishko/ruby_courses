class MembershipDecorator < ApplicationDecorator
  decorates :membership

  #include CanCan::ControllerAdditions::ClassMethods

  def display_name
    "#{membership.user.first_name} #{membership.user.last_name}"
  end
  
  def role_name
    return "Owner" if membership.user == membership.account.owner
    return membership.role.capitalize
  end
end