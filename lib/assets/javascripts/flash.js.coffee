$.namespace("GoodsMaster.flash")

GoodsMaster.flash.init = ->
  $flash = $(".flash")

  # Auto-closing alert
  fd = if $flash.hasClass("alert")
    10000
  else
    5000

  $flash.delay(fd).fadeOut("slow").queue ->
    $flash.remove()

  # Bootstrap-alert close functionality
  $flash.alert('close')


$(document).ready ->
  GoodsMaster.flash.init()


