class PhotoDecorator < ApplicationDecorator
  decorates :photo
  
  def show_link(opts = {})
    decorator = ProductDecorator.decorate(photo.product)
    decorator.show_link(opts.merge(anchor: photo.id))
  end
end
