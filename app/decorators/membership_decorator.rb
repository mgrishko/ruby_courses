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
    membership.user.full_name
  end

  def email
    membership.user.email
  end

  def role_name
    I18n.t("roles.#{membership.owner? ? "owner" : membership.role}", scope: i18n_scope)
  end

  # Setups nested attributes for membership form
  def setup_nested
    self.membership.tap do |a|
      a.user = User.new if a.user.nil?
    end
    self
  end

  def show_password(options = {})
    if membership.user.password.present?
      if :format == :html
        "Password:
        %br
        #{membership.user.password}"
      else
        "Password:
        #{membership.user.password}"
      end
    end
  end

  def invitation(options = {})
    if membership.invitation_note.present?
      if :format == :html
        "%p
          #{membership.invited_by.first_name}
          also says:
        %pre= #{membership.invitation_note}"
      else
        "#{membership.invited_by.first_name} also says:

        #{membership.invitation_note}"
      end
    end
  end
end
