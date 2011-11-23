class ProductDecorator < ApplicationDecorator
  decorates :product
  allows :name, :description
  include CommonLinks

  def show_link
    h.show_link(product, name: :name, fallback: true)
  end

  private

  def scope
    "products.defaults"
  end

end