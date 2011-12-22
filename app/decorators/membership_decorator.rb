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

  # Sets view content for password label
  #
  # @param [Hash] optional. if options[:format] == :html it sets password content only for html,
  # other, sets for text format
  def password_label(options = {})
    if membership.user.password.present?
      password = membership.user.password
      str = "Password:
      #{password}".split("\n")
      str = str.insert(1, "      %br") if options[:format] == :html
      str.join("\n")
      #if options[:format] == :html
        #"Password:
        #%br
        ##{password}"
      #else
        #"Password:
        ##{password}"
      #end
    end
  end

  # Sets view content for invitation note
  #
  # @param [Hash] optional. if options[:format] == :html it sets invitation note only for html,
  # other, sets for text format
  def invitation_label(options = {})
    if membership.invitation_note.present?
      first_name = membership.invited_by.first_name
      invitation_note = membership.invitation_note
      if options[:format] == :html
        "%p
          #{first_name}
          also says:
        %pre= #{invitation_note}"
      else
        "#{first_name} also says:

        #{invitation_note}"
      end
    end
  end
end
