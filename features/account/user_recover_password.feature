@wip
Feature: User recover password
  In order to recover user password
  A user
  Should be able to recover self password

  Background: Activated account exists
    Given an activated account
    And an unauthenticated user

  Scenario: User recover password successfully
    And he is on the user sign in page
    When he follows "Forgot your password?" within actions
    And he submits valid email
    #And he visit the reset password page
    Then he should receive an email with reset password instructions
    When they follow "Change my password" in the email
    Then he should be redirected to the change password page
    #When he fill in hidden_field "user_reset_password_token" with reset_password_token
    When he submits new password and confirm it
    #And he should see notice message "Your password was changed successfully. You are now signed in."
    Then user should be redirected back to the restricted page
    When he follows "Sign out" within topbar
    And he submits email and new password
    And he should see notice message "Signed in successfully."

  Scenario: User unsuccessfully recover password
    And he is on the user sign in page
    When he follows "Forgot your password?" within actions
    And he submits invalid email
    Then user should see that current email not found
