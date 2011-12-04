# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$.namespace("GoodsMaster.photos")

GoodsMaster.photos.init = ->
  $form = $("#new_photo")

  $form.find("input[type='file']").on "change", (event) ->
    $form.find("a").remove()
    $form.append(GoodsMaster.ajax_loader.img)
    $form.submit()

$(document).ready ->
  GoodsMaster.photos.init()



