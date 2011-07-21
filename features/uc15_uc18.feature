@javascript
Feature: Retailer makes specific subscription
  In order to test specific subscription process
  As a retailer
  I want to create a new specific subscription

  Scenario: Create a specific subscription
    Given "supplier" has gln "1234" and password "1234"
      And "retailer" has gln "4321" and password "1234"
      And I have a base_item with gtin "123123123"
    When I logged in as "retailer"
      And I go to the suppliers page
      And I follow "Supplier"
      And I follow "123123123"
      And I press "subscribe_by_id_btn"
      And I wait for 1 second
    Then a subscription should exist with specific: true, status: "active"
    When I logged in as "supplier"
    When I go to the base_items page
    And I follow "123123123"
    Then I should see "Retailer"

