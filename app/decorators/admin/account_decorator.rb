class Admin::AccountDecorator < ApplicationDecorator
  decorates :account
  allows :subdomain, :company_name

  def country
    Carmen::country_name(account.country)
  end

  def state
    I18n.t("states.#{account.state}", scope: i18n_scope)
  end

  def activation_link
    h.link_to I18n.t("activate", scope: i18n_scope), [:activate, :admin, account]
  end
end