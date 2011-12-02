<% unless @photo.errors.any? %>
  $("#photo").replaceWith "<%= escape_javascript(render(partial: @photo)) %>"

  GoodsMaster.photos.init()
<% end %>