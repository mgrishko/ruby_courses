Feature: Visibility of the password
  In order to display filling password
  A user
  Should be able change visibility of password

  @javascript
  Scenario: User successfully show and hide password on Sign up page
    Given company representative is on the sign up page
    When he fill password with "password"
    And text in password field should be "password"
    Then he should not see filled password
    When he check "Show password"
    Then he should see filled password
    And he uncheck "Show password"
    Then he should not see filled password

  @javascript
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

  @javascript
  Scenario: User successfully show and hide password on Profile page
    Given an activated account
    Given an authenticated user with viewer role
    And he is on the user profile page
    When he fill password and current password with "password"
    Then he should not see filled passwords
    When he check "Show password"
    Then he should see filled password
    And he uncheck "Show password"
    Then he should not see filled password
    And text in password and current password field should be "password"
