module ApplicationHelper
  # Sets content for title in head and for body header.
  #
  # @param [String] page_title page title
  # @param [Hash] options optional. if options[:body] == true sets content for body title.
  def title(page_title, options = {})
    if options[:body] == true
      body_title = content_tag(:h2, page_title.to_s)
      content_for(:body_title, body_title.to_s)
      content_for(:head_title, page_title.to_s)
    else
      content_for(:head_title, page_title.to_s)
    end
  end

  # Prepares ability for current membership.
  #
  # return [MembershipAbility] membership ability for current user in current account.
  def current_ability
    @current_ability ||= MembershipAbility.new(current_membership)
  end

  # Prepares account membership if current user has membership for current account and account is not nil.
  # Otherwise returns nil.
  #
  # return [Membership, nil] membership on current user in current account.
  def current_membership
    @current_membership ||= begin
      current_user && current_account ? current_account.memberships.where(user_id: current_user.id).first : nil
    end
  end

  # Returns account if account can be found by current request subdomain. Otherwise returns nil.
  #
  # return [Account, nil] account for current subdomain if account subdomain or nil.
  def current_account
    unless controller.request.subdomain == "app"
      @current_account ||= Account.where(subdomain: controller.request.subdomain).first
    end
  end
end
