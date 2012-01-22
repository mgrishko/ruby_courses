Feature: User recover password
  In order to recover user password
  A user
  Should be able to recover self password

  Background: Activated account exists
    Given an activated account

  Scenario: User recover password successfully
    And he is on the user sign in page
    When he follows "Forgot your password?" within actions
    And he submits valid email
    Then he should see password recovery notice message
    Then save and open all html emails
    And he should receive an email with reset password instructions
    When they click the first link in the email
    Then he should be redirected to the change password page
    When he submits new password and valid confirm it
    Then he should see success sign up notice message
    And user should be redirected back to the restricted page
    When he follows "Sign out" within topbar
    And he submits email and new password
    Then he should see notice message "Signed in successfully."
    And user should be redirected back to the home page

  Scenario: User tries to recover password with invalid token
    And he is on the user sign in page
    When he follows "Forgot your password?" within actions
    And he submits valid email
    And he goes to the password edit page with invalid token
    And he submits new password and valid confirm it
    Then he should see field error "Reset password token is invalid"

  Scenario: User submit invalid email
    And he is on the user sign in page
    When he follows "Forgot your password?" within actions
    And he submits invalid email
    Then save and open all html emails
    And he shouldn't receive an email with reset password instructions

  Scenario: User unsuccessfully recover password
    And he is on the user sign in page
    When he follows "Forgot your password?" within actions
    And he submits valid email
    Then save and open all html emails
    And he should receive an email with reset password instructions
    When they click the first link in the email
    Then he should be redirected to the change password page
    When he submits new password and invalid confirm it
    Then he should see message "doesn't match confirmation"
