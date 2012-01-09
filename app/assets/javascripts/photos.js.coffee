# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$.namespace("GoodsMaster.photos")

GoodsMaster.photos.init = ->
  $form = $("#new_photo")
  
  $form.live 'ajax:error', ()->
    $form.find("a").show()
    $form.find(GoodsMaster.ajax_loader.element).remove()

  $form.find("input[type='file']").on "change", (event) ->
    valid = true
    errorMessages = []
    
    if !/(\.bmp|\.gif|\.jpg|\.jpeg)$/i.test(this.value)
      valid = false
      errorMessages.push("invalid image file type")
    
    if typeof(window.FileReader) == 'function'
      file = this.files[0]
      if file.size > (1024 * 1024)
        valid = false
        msg = I18n.t("errors.messages.size_too_big", {file_size: "1MB"})
        errorMessages.push(msg)
    
    if valid
      $form.find("a").hide()
      $form.append(GoodsMaster.ajax_loader.img)
      $form.submit()
    else
      $form.find("span.help-inline").html(errorMessages.join(", "))

$(document).ready ->
  GoodsMaster.photos.init()
