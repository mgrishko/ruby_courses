class ProductDecorator < ApplicationDecorator
  decorates :product

  #def show_link
    #h.show_link(product, name: :name, fallback: true)
  #end
  class << self
    def create_link(opts = {})
      if h.can?(:create, Product)
        #model_class = (model.kind_of?(Class) ? model : model.class)
        h.link_to(I18n.t("products.defaults.new"), h.new_product_path, opts)
      end
    end
  end
end
