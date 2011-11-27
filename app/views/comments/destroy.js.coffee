$("#comments tr#<%= @comment.id %>").fadeOut().queue ->
  $(this).remove()