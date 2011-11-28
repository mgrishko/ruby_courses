class ProductDecorator < ApplicationDecorator
  decorates :product
  allows :name, :description, :version, :created_at, :updated_at
  include CommonLinks

  def show_link
    h.show_link(product, name: :name, fallback: true)
  end
  
  def show_version_link version
    text = I18n.t("version", scope: scope, version: version)
    h.can?(:read, product) ? h.link_to(text, h.product_version_path(id: product.id, version: version)) : text
  end

  def version_count
    return product.versions.length + 1
  end

  def version_date version
    return "" if h.cannot?(:read, product) 
    
    return product.updated_at.strftime("%b %d, %Y") if version == product.version
      
    if (1..(product.version - 1)).include?(version)
      return product.versions.where(:version => version).first.updated_at.strftime("%b %d, %Y")
    end
    
    return ""
  end

  private

  def scope
    "products.defaults"
  end
end