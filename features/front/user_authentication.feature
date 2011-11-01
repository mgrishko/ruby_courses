Feature: User authentication
  In order to restrict access to account data
  A user
  Should be able to sign in and sign out

  Scenario: User signs in successfully
    Given an unauthenticated user
    When the user tries to access account home page
    Then he should be redirected to the user login page
    When user submits valid email and password
    Then he should be redirected back to the account home page

  Scenario Outline: User enters wrong email or password
    Given an unauthenticated user
    And he is on the sign in page
    When user submits <email> email and <password> password
    Then he should be redirected back to the sign in page
    And user should see alert message "Invalid email or password"
    Examples:
      | email | password |
      | valid | wrong    |
      | wrong | valid    |

  Scenario: User signs out
    Given an authenticated user
    When he signs out
    And he returns next time
    Then user should be signed out
