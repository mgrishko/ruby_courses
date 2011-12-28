@wip
Feature: User recover password
  In order to recover user password
  A user
  Should be able to recover self password

  Background: Activated account exists
    Given an activated account
    And an unauthenticated user with viewer role

  Scenario: User recover password successfully
    And he is on the user sign in page
    When he follows "Forgot your password?" within actions
    And he submits valid email
    Then he should see notice message "If your e-mail exists on our database, you will receive a password recovery link on your e-mail"
    Then save and open all html emails
    Then he should receive an email with reset password instructions
    When they click the first link in the email
    Then he should be redirected to the change password page
    When he submits new password and confirm it
    And he should see notice message "Your password was changed successfully. You are now signed in."
    Then user should be redirected back to the restricted page
    When he follows "Sign out" within topbar
    And he submits email and new password
    And he should see notice message "Signed in successfully."
    And user should be redirected back to the home page

  Scenario: User tries to recover password with invalid token
    And he is on the user sign in page
    When he follows "Forgot your password?" within actions
    And he submits valid email
    And he goes to the password edit page with invalid token
    And he submits new password and confirm it
    And he should see "Reset password token is invalid" message


  Scenario: User unsuccessfully recover password
    And he is on the user sign in page
    When he follows "Forgot your password?" within actions
    And he submits invalid email
    Then he should see notice message "If your e-mail exists on our database, you will receive a password recovery link on your e-mail"
