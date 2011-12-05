class ProductDecorator < ApplicationDecorator
  decorates :product

  # Returns html code for a link to a specific product version.
  # If product version is current version it returns only link name.
  #
  # @param [Product] current version of product
  # @param [Product] last version of product
  # @return [String] link or name
  def version_link(current_version, last_version)
    path = product.version == last_version.version ?
        h.product_path(last_version) : h.product_version_path(last_version, version: product.version)

    h.link_to_if(product.version != current_version.version,
                 I18n.t("version", scope: i18n_scope, number: product.version),
                 path)
  end

  # Returns product version date:.
  #   created_at for version 1
  #   updated_at for next versions
  #
  # @return [String] link or name
  def version_date
    date = product.version == 1 ? product.created_at : product.updated_at
    h.content_tag(:span, "(#{date.try(:strftime, '%d %b %Y, %H:%M')})")
  end
end