Feature: Admin views account events
  In order to monitor changes in accounts
  An admin
  Should be able to view account events

  @wip
  Scenario: Admin views account events
    Given an activated account
    And an unauthenticated admin
    And an authenticated user with editor role
    When he adds a new product
    And admin signs in
    And admin goes to the events page
    Then he should see "New" event
