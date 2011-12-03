class ProductDecorator < ApplicationDecorator
  decorates :product
  include CommonLinks

  def show_link(opts = {})
    h.show_link(product, opts.merge(name: :name, fallback: true))
  end
end