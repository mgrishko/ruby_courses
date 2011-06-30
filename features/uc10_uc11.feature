@javascript
Feature: Subscription Accepting
  In order to test subscription aceptance by retailer
  As a retailer
  I want to accept subscription

  Scenario: Refuse subscription result.
    Given "supplier" has gln "1234" and password "1234"
    Given "retailer" has gln "4321" and password "1234"
    And the following subscriptions exist
      |status|retailer_id|supplier_id|
      |active| 3 | 2 |
    And I logged in as "supplier"
    And I have a base_item with gtin "1234567"
    When I go to the base_item page
    And I press "Правка"
    And I wait for 2 seconds
    And I follow "править" within "#base_item"
    And I fill in "Any brand" for "base_item_subbrand"
    And I press "Применить"
    And I press "Опубликовать"
    When I logged in as "retailer"
    And I go to the subscription_results page
    And I follow "1234"
    And I follow "Отменить"
    And I follow "Received Items"
    Then I should not see "1234567"

  Scenario: Accept subscription result.
    Given "supplier" has gln "1234" and password "1234"
    Given "retailer" has gln "4321" and password "1234"
    And the following subscriptions exist
      |status|retailer_id|supplier_id|
      |active| 2 | 1 |
    And I logged in as "supplier"
    And I have a base_item with gtin "1234567"
    When I go to the base_item page
    And I press "Правка"
    And I wait for 2 seconds
    And I follow "править" within "#base_item"
    And I fill in "Any brand" for "base_item_subbrand"
    And I press "Применить"
    And I press "Опубликовать"
    When I logged in as "retailer"
    And I go to the subscription_results page
    And I follow "1234"
    And I follow "Акцептовать"
    And I follow "Received Items"
    Then I should see "1234567"

