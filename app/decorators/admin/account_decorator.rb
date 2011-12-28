class Admin::AccountDecorator < ApplicationDecorator
  decorates :account
  allows :subdomain, :company_name

  def country
    Carmen::country_name(account.country)
  end

  def state
    I18n.t("states.#{account.state}", scope: i18n_scope)
  end

  # Returns a link that activated the account
  def activation_link
    h.link_to I18n.t("activate", scope: i18n_scope), [:activate, :admin, account]
  end
  
  # Returns a link that logs the admin as the account owner
  def login_as_owner_link
    h.link_to I18n.t("login_as_owner", scope: i18n_scope), [:login_as_owner, :admin, account]
  end
end