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
    Then he should receive an email with reset password instructions
    When they follow "Change my password" in the email
    #Then he should be redirected to the change password page
    When he submits new password and confirm it
    And user signs out
    And user returns next time
    And he submits email and new password
    Then user should be redirected back to the restricted page

  Scenario: User unsuccessfully recover password
    And he is on the user sign in page
    When he follows "Forgot your password?" within actions
    And he submits invalid email
    Then user should see that current email not found
