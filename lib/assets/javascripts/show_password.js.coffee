$.namespace("GoodsMaster.show_password")

GoodsMaster.show_password.init = ->

  $show_password = $('#show_password')

  $show_password.change ->
    if $(this).attr('checked')
      $(':input[type=password]').each ->
        marker = $('<span />').insertBefore(this)
        $(this).detach().attr('type', 'text').addClass('pre-pass').insertAfter(marker)
        marker.remove()
      # Not sure, but following code don't work in IE 6-7-8
      # need testing
      #$(':input[type=password]').each ->
        #$(this).addClass('pre-pass').get(0).type = 'text'

    else
      $('.pre-pass').each ->
        marker = $('<span />').insertBefore(this)
        $(this).detach().attr('type', 'password').removeClass('pre-pass').insertAfter(marker)
        marker.remove()
      # Not sure, but following code don't work in IE
      # need testing
      #$('.pre-pass').each ->
        #$(this).removeClass('pre-pass').get(0).type = 'password'


$(document).ready ->
  GoodsMaster.show_password.init()
