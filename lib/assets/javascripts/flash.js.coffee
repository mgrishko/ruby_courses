$.namespace("GoodsMaster.flash")

GoodsMaster.flash.init = ->
  $flash = $(".flash")

  # Auto-closing alert
  fd = if $flash.hasClass("alert")
    10000
  else
    3000

  $flash.delay(fd).fadeOut("slow").queue ->
    $flash.alert('close')

$(document).ready ->
  GoodsMaster.flash.init()


