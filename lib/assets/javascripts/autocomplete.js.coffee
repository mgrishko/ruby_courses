class MultiAutocomplete
  constructor: (@input) ->
    value = input.val()
    @input.tokenInput input.attr('data-autocomplete-url') + "?", 
      theme: "goodsmaster"
      queryParam: "query"
      preventDuplicates: true
      minChars: 2
      hintText: I18n.t('autocomplete.multi.hint')
      noResultsText: I18n.t('autocomplete.multi.no_results')
      searchingText: I18n.t('autocomplete.multi.searching')

    @input.tokenInput("add", {id: v, name: v}) for v in value.split(",") if value
    
    width = @input.width()
    $("div.token-input-dropdown-goodsmaster").width(width)
    input_box = $("#token-input-" + input.attr("id"))
    # Set width of the generated input box to 1 so it is not wrapped
    # to the next line after tags
    input_box.width(1).closest("ul.token-input-list-goodsmaster").width(width)
    
    # Add new tag on ',' or Enter key up
    input_box.on "keyup", (event) ->
      return unless event.keyCode in [188, 13]
      new_value = input_box.val()
      new_value = new_value.substring(0, new_value.length - 1) if event.keyCode == 188
      @input.tokenInput("add", { id: new_value, name: new_value }) if new_value
      input_box.val("")
    
    # Form not submitted when Enter is pressed
    input_box.on "keydown", (event) ->
      event.preventDefault() if event.keyCode == 13

class SingleAutocomplete
  constructor: (@input) ->
    @input.autocomplete
      minLength: 2
    
      # Loads options and builds array of items 
      source: (request, response) ->
        $.getJSON input.attr('data-autocomplete-url') + "?", { query: request.term }, (data, textStatus, jqXHR) ->
          items = for entry in data
            do (entry) -> 
              value: entry.name
              label: entry.name.replace(request.term, "<strong>#{request.term}</strong>")
          response(items, textStatus, jqXHR)
    
      # Focusing an item doesn't change the input text 
      focus: (event, ui) -> false
      
    # Override _renderItem to use html as an item text
    .data("autocomplete")._renderItem = (ul, item) ->
      $("<li></li>").data("item.autocomplete", item).append($("<a></a>").html(item.label)).appendTo(ul);

$(document).ready ->
  # Initializes multi-value autocompletes
  $('input[data-autocomplete="multi"]').each (i, elem) ->
    new MultiAutocomplete($(elem))
    
  # Initializes single-value autocompletes
  $('input[data-autocomplete="single"]').each (i, elem) ->
    new SingleAutocomplete($(elem))
