<% if @comment.errors.any? %>
  $("#new_comment").replaceWith "<%= escape_javascript(render("comments/form", commentable: @comment.commentable)) %>"

<% else %>
  $("<%= escape_javascript(render(partial: @comment)) %>").appendTo("#comments_list").hide().fadeIn()

  GoodsMaster.comments.init()

  $("#new_comment")[0].reset()

<% end %>
