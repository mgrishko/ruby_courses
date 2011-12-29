Feature: Logs in as the account owner
  In order to manage the account as its owner
  An admin
  Should be able to login to an account as its owner

  Scenario: Admin activates account
    Given company representative has a new account
    And an authenticated admin
    When he opens the account page
    And logs in as the account owner
    Then he should be on the company account home page
