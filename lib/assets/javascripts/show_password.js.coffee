$.namespace("GoodsMaster.show_password")

GoodsMaster.show_password.init = ->

  $show_password = $('#show_password')

  $show_password.change ->
    if $(this).attr('checked')
      $(':input[type=password]').each ->
        marker = $('<span />').insertBefore(this)
        $(this).detach().attr('type', 'text').addClass('pre-pass').insertAfter(marker)
        marker.remove()
      #$(':input[type=password]').each ->
        #$(this).addClass('pre-pass').get(0).type = 'text'

    else
      $('.pre-pass').each ->
        marker = $('<span />').insertBefore(this)
        $(this).detach().attr('type', 'password').removeClass('pre-pass').insertAfter(marker)
        marker.remove()
      #$('.pre-pass').each ->
        #$(this).removeClass('pre-pass').get(0).type = 'password'


$(document).ready ->
  GoodsMaster.show_password.init()
