class MembershipDecorator < ApplicationDecorator
  decorates :membership

    def self.invitation_link(opts = {})
      if h.can?(:create, Membership)
        h.link_to(I18n.t("memberships.defaults.invite"), h.new_membership_path, opts)
      end
    end

    def self.role_select_options
      Membership::ROLES.collect{|r| [I18n.t("roles.#{r}", scope: "memberships.defaults"), r] }
    end

  def display_name
    model.user.full_name
  end

  def email
    model.user.email
  end

  def role_name
    I18n.t("roles.#{model.owner? ? "owner" : model.role}", scope: scope(model))
  end

  # Setups nested attributes for membership form
  def setup_nested
    self.model.tap do |a|
      a.user = User.new if a.user.nil?
    end
    self
  end
end
