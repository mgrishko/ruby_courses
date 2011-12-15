class MultiAutocomplete
  constructor: (@input) ->
    input = @input
    
    value = input.val()
    input.tokenInput(input.attr('data-autocomplete-url') + "?", 
      { theme: "goodsmaster", queryParam: "query", preventDuplicates: true })
    input.tokenInput("add", {id: v, name: v}) for v in value.split(",") if value
    
    width = input.width()
    $("div.token-input-dropdown-goodsmaster").width(width)
    input_box = $("#token-input-" + input.attr("id"))
    # Set width of the generated input box to 1 so it is not wrapped
    # to the next line after tags
    input_box.width(1)
    input_box.closest("ul.token-input-list-goodsmaster").width(width)
    
    # Add new tag on ',' or Enter key up
    input_box.on "keyup", (event) ->
      return unless event.keyCode in [188, 13]
      new_value = input_box.val()
      new_value = new_value.substring(0, new_value.length - 1) if event.keyCode == 188
      input.tokenInput("add", {id: new_value, name: new_value}) if new_value
      input_box.val("")
    
    # Form not submitted when Enter is pressed
    input_box.on "keydown", (event) ->
      return unless event.keyCode == 13
      event.preventDefault()
  
$(document).ready ->
  $('input[data-autocomplete="multi"]').each (i, elem) ->
    new MultiAutocomplete($(elem))
