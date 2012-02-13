$last_group = $(".products article").last()

<% products = @products.to_a %>
<% group_name = products.first.send(@group_by.to_sym) %>

group = "<%= group_name %>"

if group == $last_group.attr("data-group")
  <% products = products.select { |p| p.send(@group_by.to_sym) == group_name } %>

  $last_row = $last_group.find(".row").last()

  if $last_row.find(".item").length == 1
    <% product = products.delete_at(0) %>
    $last_row.append "<%= escape_javascript(render product, column: 2) %>"

  $last_group.append "<%= escape_javascript(render "product_group", products: products) %>"

  $("#pager").replaceWith "<%= escape_javascript(render "product_groups", skip_first: true) %>"

else
  $("#pager").replaceWith "<%= escape_javascript(render "product_groups", skip_first: false) %>"


GoodsMaster.products.initPager()