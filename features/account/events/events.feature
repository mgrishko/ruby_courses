Feature: New event
  In order to track changes in products
  An user
  Should be able to see the log of events

  Background: Account exists
    Given an activated account

  @wip
  Scenario: Editor sees a new event when he adds a new product
    Given an authenticated user with editor role
    When he adds a new product
    And he goes to the home page
    Then he should see "Product added" event

  @wip
  Scenario: Editor sees a new event when he adds a new product
    Given that account has a product
    And an authenticated user with editor role
    When he updates the product
    Then he should see "Product updated" comment on the product page
    And he cannot delete this comment
    When he goes to the home page
    Then he should see "Product updated" event
