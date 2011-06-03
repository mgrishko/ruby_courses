@javascript
Feature: Retailer subscribes
  In order to test subscription process
  As a retailer
  I want to create a new subscription

  Scenario: Subscribe and supplier should see the subscription
    Given "supplier" has gln "1234" and password "1234"
    And "retailer" has gln "4321" and password "1234"
    And I have a base_item
    When I logged in as "retailer"
    And go to the suppliers page
    And press "Подписаться"
    Then a subscription should exist with retailer_id: 2, supplier_id: 1, status: "active"
    When I logged in as "supplier"
    And I go to the base_items page
    And I click element ".bi"
    Then I should see "Retailer"

  Scenario: Unsubscribe
    Given "supplier" has gln "1234" and password "1234"
    And "retailer" has gln "4321" and password "1234"
    And the following subscriptions exist
      |retailer_id|supplier_id|status|
      | 2 | 1 | active |
    When I logged in as "retailer"
    And go to the suppliers page
    And press "Отписаться"
    And I wait for 1 second
    Then a subscription should not exist with retailer_id: 2, supplier_id: 1, status: "active"
    Then a subscription should exist with retailer_id: 2, supplier_id: 1, status: "canceled"

