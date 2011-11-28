class ProductDecorator < ApplicationDecorator
  decorates :product
  allows :name, :description, :version
  include CommonLinks

  def show_link
    h.show_link(product, name: :name, fallback: true)
  end
  
  def show_version_link version
    text = I18n.t("version", scope: scope, version: version)
    h.can?(:read, product) ? h.link_to(text, h.product_version_path(id: product.id, version: version)) : text
  end

  private

  def scope
    "products.defaults"
  end
end