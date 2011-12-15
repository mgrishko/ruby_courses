class MultiAutocomplete
  constructor: (@input) ->
    input = @input
    
    value = input.val()
    input.tokenInput(input.attr('data-autocomplete-url') + "?", 
      { theme: "goodsmaster", queryParam: "query", preventDuplicates: true })
    input.tokenInput("add", {id: v, name: v}) for v in value.split(",")
    
    width = input.width()
    $("div.token-input-dropdown-goodsmaster").width(width)
    input_box = $("#token-input-" + input.attr("id"))
    input_box.width(1)
    input_box.closest("ul.token-input-list-goodsmaster").width(width)
    
    input_box.on "keyup", (event) ->
      return unless event.keyCode == 188
      new_value = input_box.val()
      new_value = new_value.substring(0, new_value.length - 1)
      input.tokenInput("add", {id: new_value, name: new_value}) if new_value
      input_box.val("")
  
$(document).ready ->
  $('input[data-autocomplete="multi"]').each (i, elem) ->
    new MultiAutocomplete($(elem))
