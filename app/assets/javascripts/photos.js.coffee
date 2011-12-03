# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$.namespace("GoodsMaster.photos")

GoodsMaster.photos.init = ->
  $("#new_photo a").on "click", (event) ->
    $("#new_photo input[type='file']").click()

  $("#new_photo input[type='file']").on "change", (event) ->
    $("#new_photo a").remove()
    $("form#new_photo").submit()


$(document).ready ->
  GoodsMaster.photos.init()



