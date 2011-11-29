class ProductDecorator < ApplicationDecorator
  decorates :product
  include CommonLinks

  def show_link
    h.show_link(product, name: :name, fallback: true)
  end
end