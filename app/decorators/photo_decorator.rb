class PhotoDecorator < ApplicationDecorator
  decorates :photo

  def destroy_link(opts = {})
    if h.can?(:destroy, photo)
      opts = (opts || {}).with_indifferent_access
      opts.merge!(method: :delete, remote: true)
      h.link_to(I18n.t("destroy", scope: scope), [photo.product, photo], opts)
    end
  end

  private

  def scope
    "photos.defaults"
  end
end
