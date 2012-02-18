@javascript
Feature: Visibility of the password
  In order to display filling password
  A user
  Should be able change visibility of password

  Scenario: User successfully show and hide password on Sign up page
    Given company representative is on the sign up page
    When he fill password with "password"
    And text in password field should be "password"
    Then he should not see filled password
    When he check "Show password"
    Then he should see filled password
    And he uncheck "Show password"
    Then he should not see filled password

  Scenario: User successfully show and hide password on Sign in page
    Given an activated account
    Given an authenticated user with viewer role
    And he is on the user sign in page
    When he fill password with "password"
    Then he should not see filled password
    When he check "Show password"
    Then he should see filled password
    And he uncheck "Show password"
    Then he should not see filled password
    And text in password field should be "password"

  Scenario: User successfully show and hide password on Profile page
    Given an activated account
    Given an authenticated user with viewer role
    And he is on the user profile page
    When he fill password and current password with "password"
    Then he should not see filled password and current password
    When he check "Show password"
    Then he should see filled password and current password
    And he uncheck "Show password"
    Then he should not see filled password and current password
    And text in password and current password field should be "password"

  Scenario: User successfully show and hide password on Password Recovery page
    Given an activated account
    Given an unauthenticated user with viewer role
    And he goes to the password edit page with invalid token
    When he fill password and password confirmation with "password"
    Then he should not see filled passwords and password confirmation
    When he check "Show password"
    Then he should see filled password
    And he uncheck "Show password"
    Then he should not see filled password and password confirmation
    And text in password and password confirmation field should be "password"
