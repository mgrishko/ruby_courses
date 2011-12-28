# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$.namespace("GoodsMaster.comments")

GoodsMaster.comments.init = ->
  $comment = $(".comment")

  $comment.on "mouseover", (event) ->
    $(this).find("a.delete_img").show()

  $comment.on "mouseleave", (event) ->
    $(this).find("a.delete_img").hide()

$(document).ready ->
  GoodsMaster.comments.init()
