@javascript
@wip
Feature: Retailer makes specific subscription
  In order to test specific subscription process
  As a retailer
  I want to create a new specific subscription

  Scenario: Create a specific subscription
    Given "supplier" has gln "1234" and password "1234"
      And "retailer" has gln "4321" and password "1234"
      And I have a base_item
    When I logged in as "retailer"
      And I go to the suppliers page
      And I click element ".bi-image"
      And I click element ".bi-image"
      And I press "Подписаться"
    Then a subscription should exist
    When I logged in as "supplier"
    When I go to the base_items page
      And I click element ".bi"
    Then I should see "Retailer"

