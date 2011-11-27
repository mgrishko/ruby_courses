class ProductDecorator < ApplicationDecorator
  decorates :product
  include CommonLinks

  def show_link
    h.show_link(product, name: :name, fallback: true)
  end

  def setup_nested
    self.product.tap do |a|
      a.comments.build if a.comments.empty?
    end
    self
  end

  private

  def scope
    "products.defaults"
  end

end