Feature: Account activation
  In order allow access to company account
  An admin
  Should be able to activate company account

  Scenario: Admin activates account
    Given an authenticated admin
    And not activated company account
    When admin goes to the accounts page
    And he activates the account
    Then he should see notice message "Account was successfully activated."
    # Email steps
    And an account owner should receive an invitation email
    When he follows company account link
    And user signs in with valid credentials
    Then he should be on the company account home page

