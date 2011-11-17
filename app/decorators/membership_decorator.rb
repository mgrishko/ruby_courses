class MembershipDecorator < ApplicationDecorator
  decorates :membership
  include CommonLinks

  def display_name
    "#{membership.user.first_name} #{membership.user.last_name}"
  end
  
  def role_name
    return I18n.t("memberships.roles.owner") if membership.user == membership.account.owner
    return I18n.t("memberships.roles.#{membership.role}")
  end
  
  def role_select_options
    Membership::ROLES.collect{|r| [I18n.t("memberships.roles.#{r}"), r] }
  end
end