Feature: User authentication
  In order to restrict access to account data
  A user
  Should be able to sign in and sign out

  Background: Activated account exists
    Given an activated account

  Scenario: User signs in successfully
    And an unauthenticated user with admin role
    When he navigates to products page
    Then he should be redirected to the user sign in page
    When user filling the valid email and password
    And he check checkbox "Show password"
    Then he should see filled password
    And he uncheck checkbox "Show password"
    Then he should not see filled password
    When he clicks button "Sign in"
    Then he should be redirected back to the products page

  Scenario Outline: User enters wrong email or password
    Given an unauthenticated user
    And he is on the user sign in page
    When user submits the <email> email and <password> password
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

  Scenario: Non-member of an account is prompted to login
    And an authenticated user with admin role
    And another active account
    When user navigates to another account home page
    Then he should be prompted to login to another account

  Scenario: Anonimous is prompted to login
    Given another active account
    When user navigates to another account home page
    Then he should be prompted to login to another account

  Scenario: User is signed out when logs in as another user
    And an authenticated user with admin role
    And another active account
    When user navigates to another account home page
    Then he should be prompted to login to another account
    When he logs in as another account user
    And he navigates to account home page
    Then he should be prompted to login to account
