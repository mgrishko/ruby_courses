Feature: User authentication
  In order to restrict access to account data
  A user
  Should be able to sign in and sign out

  Background: Activated account exists
    Given an activated account

  Scenario: User signs in successfully
    Given an unauthenticated user
    When the user tries to access a restricted page
    Then he should be redirected to the user sign in page
    When user submits valid email and password
    Then user should be redirected back to the restricted page

  Scenario Outline: User enters wrong email or password
    Given an unauthenticated user
    And he is on the user sign in page
    When user submits <email> email and <password> password
    Then he should be redirected to the user sign in page
    And user should see alert message "Invalid email or password"
    Examples:
      | email | password |
      | valid | wrong    |
      | wrong | valid    |

  Scenario: User signs out
    Given an authenticated user
    When user signs out
    And user returns next time
    Then user should be signed out
