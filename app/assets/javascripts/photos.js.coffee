# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$.namespace("GoodsMaster.photos")

$(document).ready ->
  GoodsMaster.photos.init()

GoodsMaster.photos.init = ->
  $form = $(".new_photo, .edit_photo")
  
  $form.live 'ajax:error', ()->
    $form.find("a").show()
    $form.find(GoodsMaster.ajax_loader.element).remove()

  $form.find("input[type='file']").on "change", (event) ->
    valid = true
    errorMessages = []
    
    validator = new GoodsMaster.validators.FileValidations(this)
    
    addErrorMsg = (msg) ->
      if msg
        errorMessages.push(msg)
        valid = false
    
    addErrorMsg validator.validateMaxFileSize(1024 * 1024, "1MB")
    addErrorMsg validator.validateImageFileType()
      
    if valid
      $form.find("a").hide()
      $form.append(GoodsMaster.ajax_loader.img)
      $form.submit()
    else
      $form.find("span.help-inline").html(errorMessages.join(", "))

# Loads delayed image
GoodsMaster.photos.show = (url)->
  setTimeout (->
      $.ajax({
          url: url,
          dataType: "script",
          type:'GET'
      })
    ), 3000
