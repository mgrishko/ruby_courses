Feature: Account activation
  In order allow access to company account
  An admin
  Should be able to activate company account

  Scenario: Admin activates account
    Given company representative has a new account
    And an authenticated admin
    When admin goes to the accounts page
    And he activates the account
    Then he should see notice message "Account was successfully activated."
    And an account owner should receive an activation email
    When he follows company account link
    Then he should be on the company account home page
