class MembershipDecorator < ApplicationDecorator
  decorates :membership
  include CommonLinks

  class << self
    def invitation_link(opts = {})
      if h.can?(:create, Membership)
        h.link_to(I18n.t("memberships.defaults.invite"), h.new_membership_path, opts)
      end
    end

    def role_select_options
      Membership::ROLES.collect{|r| [I18n.t("roles.#{r}", scope: "memberships.defaults"), r] }
    end
  end

  def display_name
    membership.user.full_name
  end

  def role_name
    I18n.t("roles.#{membership.owner? ? "owner" : membership.role}", scope: scope)
  end

  def setup_nested
    self.membership.tap do |a|
      a.user = User.new if a.user.nil?
    end
    self
  end

  private

  def scope
    "memberships.defaults"
  end
end