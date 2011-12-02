class ProductDecorator < ApplicationDecorator
  decorates :product

  include CommonLinks

  def show_link
    h.show_link(product, name: :name, fallback: true)
  end
  
  # Returns html code for a link to a specific product version
  def show_version_link(version)
    text = I18n.t("version", scope: scope, version: version)
    h.can?(:read, product) ? h.link_to_if(version != product.version, text, h.product_version_path(id: product.id, version: version)) : text
  end

  private

  def scope
    "products.defaults"
  end
end