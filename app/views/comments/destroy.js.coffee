$("#comments .comment#<%= @comment.id %>").fadeOut().queue ->
  $(this).remove()