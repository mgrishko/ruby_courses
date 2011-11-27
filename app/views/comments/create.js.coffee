<% if @comment.errors.any? %>
  $("#new_comment").html "<%= escape_javascript(render(partial: "comments/form")) %>"

<% else %>
  $("<%= escape_javascript(render(partial: @comment)) %>").prependTo("#comments tbody").hide().fadeIn()

  $("#new_comment")[0].reset()

<% end %>