Feature: User recover password
  In order to recover user password
  A user
  Should be able to recover self password

  Background: Activated account exists
    Given an activated account

  Scenario: Account owner recovers password successfully
    Given user is on the user sign in page
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
    Then user should be signed in
    And user should be redirected back to the home page

  Scenario: Not account owner recovers password within global subdomain
    Given an unauthenticated user with viewer role
    And he is on the global sign in page
    When he follows "Forgot your password?" within actions
    And he submits valid email
    Then he should receive an email with reset password instructions
    When they click the first link in the email
    Then he should be redirected to the change password page
    When he submits new password and valid confirm it
    Then user should be signed in
    And user should be redirected back to the home page

  Scenario: User tries to recover password with invalid token
    Given user is on the user sign in page
    When he follows "Forgot your password?" within actions
    And he submits valid email
    And he goes to the password edit page with invalid token
    And he submits new password and valid confirm it
    Then he should see field error "Reset password token is invalid"

  Scenario: User submit invalid email
    Given user is on the user sign in page
    When he follows "Forgot your password?" within actions
    And he submits invalid email
    Then save and open all html emails
    And he shouldn't receive an email with reset password instructions

  Scenario: User unsuccessfully recovers password
    Given user is on the user sign in page
    When he follows "Forgot your password?" within actions
    And he submits valid email
    Then save and open all html emails
    And he should receive an email with reset password instructions
    When they click the first link in the email
    Then he should be redirected to the change password page
    When he submits new password and invalid confirm it
    Then he should see message "doesn't match confirmation"
  
  Scenario: User cancells password recovery
    Given user is on the user sign in page
    When he follows "Forgot your password?" within actions
    And he cancels the form
    Then he should be on the account login page
