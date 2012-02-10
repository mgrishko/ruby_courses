$.namespace("GoodsMaster.show_password")

GoodsMaster.show_password.init = ->

  $show_password = $('#show_password')
  $user_password = $('#user_password')
  $user_current_password = $('#user_current_password')

  $show_password.change ->
    if $user_password.get(0).type == 'password'
      $user_password.get(0).type = 'text'
    else
      $user_password.get(0).type = "password"

  $show_password.change ->
    if $user_current_password.length
      if $user_current_password.get(0).type == 'password'
        $user_current_password.get(0).type = 'text'
      else
        $user_current_password.get(0).type = "password"

$(document).ready ->
  GoodsMaster.show_password.init()
