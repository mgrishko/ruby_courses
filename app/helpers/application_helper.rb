module ApplicationHelper
  #page_title - title in head
  #body: true - optional, show title in body > h2
  #title(name, body => true - optional, if you want to display title in body > h1)
  def title(page_title, options = {})
    if options[:body] == true
      body_title = content_tag(:h2, page_title.to_s)
      content_for(:body_title, body_title.to_s)
      content_for(:head_title, page_title.to_s)
    else
      content_for(:head_title, page_title.to_s)
    end
  end

  # Returns ability for current membership.
  #
  def current_ability
    @current_ability ||= MembershipAbility.new(current_membership)
  end

  # Returns account membership if current user has membership for current account and account is not nil.
  # Otherwise returns nil.
  def current_membership
    @current_membership ||= begin
      current_user && current_account ? current_account.memberships.where(user_id: current_user.id).first : nil
    end
  end

  # Returns account if account can be found by current request subdomain. Otherwise returns nil.
  #
  def current_account
    unless controller.request.subdomain == "app"
      @current_account ||= Account.where(subdomain: controller.request.subdomain).first
    end
  end
end
