class ProductDecorator < ApplicationDecorator
  decorates :product

  def self.create_link(opts = {})
    if h.can?(:create, Product)
      h.link_to(I18n.t("products.defaults.new"), h.new_product_path, opts)
    end
  end
end
