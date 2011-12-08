Feature: New event
  In order to track changes in products
  An user
  Should be able to see the log of events

  Background: Account exists
    Given an activated account
  
  Scenario: Editor sees a new event when he adds a new product
    Given an authenticated user with editor role
    When he adds a new product
    And he goes to the home page
    Then he should see "Created by" event

  Scenario: Editor sees "Updated by" comment when he updates a product
    Given that account has a product
    And an authenticated user with editor role
    When he updates the product
    Then he should see "Updated by" comment on the product page
    And he cannot delete this comment
    When he goes to the home page
    Then he should see "Updated by" event
  
  Scenario: Editor sees "Deleted by" event when he deletes a product
    Given that account has a product
    And an authenticated user with editor role
    When he deletes the product
    And he goes to the home page
    Then he should see "Deleted by" event
  
  @javascript
  Scenario: Editor sees "Commented by" event when he adds a comment
    Given that account has a product
    And an authenticated user with editor role
    When he adds a comment to the product
    And he follows Dashboard link
    Then he should see "Commented by" event
    