processing = <%= @photo.image.medium.url.blank? %>

if processing
  GoodsMaster.photos.show("<%= product_photo_url(@product, @photo) %>")
else
  $("#photo").replaceWith "<%= escape_javascript(render(partial: @photo)) %>"

  $("#flash").html "<%= escape_javascript(render 'layouts/partials/flash', flash: flash) %>"
  GoodsMaster.flash.init()
