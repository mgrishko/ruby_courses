@javascript
Feature: Retailer subscribes
  In order to test subscription process
  As a retailer
  I want to create a new subscription

  Scenario: Subscribe
    Given "supplier" has gln "1234" and password "1234"
    And "retailer" has gln "4321" and password "1234"
    When I logged in as "retailer"
    And go to the suppliers page
    And press "Подписаться"
    Then a subscription should exist with retailer_id: 2, supplier_id: 1, status: "active"
  Scenario: Unsubscribe
    Given "supplier" has gln "1234" and password "1234"
    And "retailer" has gln "4321" and password "1234"
    And the following subscriptions exist
      |retailer_id|supplier_id|status|
      | 2 | 1 | active |
    When I logged in as "retailer"
    And go to the suppliers page
    And press "Отписаться"
    Then a subscription should not exist with retailer_id: 2, supplier_id: 1, status: "active"
    Then a subscription should exist with retailer_id: 2, supplier_id: 1, status: "canceled"

