class PhotoDecorator < ApplicationDecorator
  decorates :photo
  
  def show_link(opts = {})
    opts_text = opts.delete(:text)
    h.link_to opts_text, h.product_path(photo.product, anchor: photo.id)
  end
end
