@dashboard
Feature: Admin authentication
  In order to restrict access to admin dashboard
  An admin
  Should be able to sign in and sign out

  Scenario: Admin signs in successfully
    Given an unauthenticated admin
    When the admin tries to access a restricted page
    Then he should be redirected to the admin sign in page
    When admin submits valid email and password
    Then admin should be redirected back to the restricted page

  Scenario Outline: Admin enters wrong email or password
    Given an unauthenticated admin
    And he is on the admin sign in page
    When admin submits <email> email and <password> password
    Then he should be redirected to the admin sign in page
    And admin should see alert message "Invalid email or password"
    Examples:
      | email | password |
      | valid | wrong    |
      | wrong | valid    |

  Scenario: Admin signs out
    Given an authenticated admin
    When admin signs out
    And admin returns next time
    Then admin should be signed out
