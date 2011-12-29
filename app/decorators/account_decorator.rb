class AccountDecorator < ApplicationDecorator
  decorates :account

  def country
    Carmen::country_name(account.country)
  end

  def state
    I18n.t("states.#{account.state}", scope: i18n_scope)
  end

  # @return [String] a link that activates the account
  def activation_link
    h.link_to I18n.t("activate", scope: i18n_scope), [:activate, :admin, account] unless account.active?
  end

  # @return [String] a link that logs the admin as the account owner
  def login_as_owner_link
    h.link_to I18n.t("login_as_owner", scope: i18n_scope), [:login_as_owner, :admin, account]
  end
end
