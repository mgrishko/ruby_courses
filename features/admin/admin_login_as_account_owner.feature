Feature: Logs in as the account owner
  In order to manage the account as its owner
  An admin
  Should be able to login to an account as its owner

  Scenario: Admin logs into an activated account as its owner
    Given an activated account
    And an authenticated admin
    When he opens the account page
    And logs in as the account owner
    Then he should be on the company account home page
