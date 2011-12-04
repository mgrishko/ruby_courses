$('#flash').html "<%= escape_javascript(render 'layouts/partials/flash', flash: flash) %>"

$("#photo").replaceWith "<%= escape_javascript(render(partial: @photo)) %>"

GoodsMaster.flash.init()