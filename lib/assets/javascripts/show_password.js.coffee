$.namespace("GoodsMaster.show_password")

$(document).ready ->
  GoodsMaster.show_password.init()

GoodsMaster.show_password.init = ->
  $(':input[type=password]').addClass('password-input')
  $passwords = $('.password-input')
  $password_checkbox = $('#show_password')

  $password_checkbox.change ->
    if $password_checkbox.attr('checked')
      $passwords.each ->
        marker = $('<span />').insertBefore(this)
        $(this).detach().attr('type', 'text').insertAfter(marker)
        marker.remove()
    else
      $passwords.each ->
        marker = $('<span />').insertBefore(this)
        $(this).detach().attr('type', 'password').insertAfter(marker)
        marker.remove()

