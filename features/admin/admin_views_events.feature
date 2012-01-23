Feature: Admin views account events
  In order to monitor changes in accounts
  An admin
  Should be able to view account events

  Scenario: Admin views account events
    Given an activated account
    And an unauthenticated admin
    And an authenticated user with editor role
    When he adds a new product
    And admin signes in
    And admin goes to the events page
    Then he should see new product event
  
  Scenario: Admin sees account registration event
    Given company representative signs up for a new account
    And an authenticated admin
    When admin goes to the events page
    Then he should see "Account" event
  
  Scenario: Admin sees user invited event
    Given an unauthenticated admin
    And an activated account
    And an authenticated user with admin role
    And he sends an account invitation      
    When admin signes in
    And admin goes to the events page
    Then he should see "Invitation" event
