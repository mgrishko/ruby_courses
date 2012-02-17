$.namespace("GoodsMaster.show_password")

GoodsMaster.show_password.init = ->

  $show_password = $('#show_password')
  # gettings DOM elements for change available type
  $user_password = $('#user_password').get(0)
  $user_current_password = $('#user_current_password').get(0)
  $user_password_confirmation = $('#user_password_confirmation').get(0)

  $show_password.change ->
    if $user_password.type == 'password'
      $user_password.type = 'text'
    else
      $user_password.type = "password"

    # check existence of element
    if $user_current_password.length > 0
      if $user_current_password.type == 'password'
        $user_current_password.type = 'text'
      else
        $user_current_password.type = "password"
    # check existence of element
    if $user_password_confirmation.length > 0
      if $user_password_confirmation.type == 'password'
        $user_password_confirmation.type = 'text'
      else
        $user_password_confirmation.type = "password"

$(document).ready ->
  GoodsMaster.show_password.init()
