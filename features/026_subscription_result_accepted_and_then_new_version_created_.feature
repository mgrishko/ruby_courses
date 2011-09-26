@javascript
Feature: Subscription results different versions behaviour
  In order to test subscription aceptance by retailer also after new version creation
  As a retailer
  I want to accept subscription and check if new version appears in inbox

  Scenario: Accept subscription result.
    Given "supplier" has gln "1234" and password "1234"
    Given "retailer" has gln "4321" and password "1234"
    And the following subscriptions exist
      |status|retailer_id|supplier_id|
      |active| 2 | 1 |
    And I logged in as "supplier"
    And I have a base_item with gtin "43210121"
    When I go to the base_item page
    And I follow "edit_base_item_btn"
    And I follow "edit_base_item_link" within "#base_item"
    And I fill in "Any brand" for "base_item_subbrand"
    And I press "base_item_submit" within "#step1"
    And I press "base_item_submit" within ".logistics"
    When I logged in as "retailer"
    And I go to the subscription_results page
    And I follow "1234"
    And I click element ".blue-btn" within ".item-right-btns"
    And I go to the retailer_items page
    Then I should see "43210121"
    When I logged in as "supplier"
    When I go to the base_item page
    And I follow "edit_base_item_btn"
    And I follow "edit_base_item_link" within "#base_item"
    And I fill in "43220120" for "base_item_gtin"
    And I press "base_item_submit" within "#step1"
    And I press "base_item_submit" within ".logistics"

    When I logged in as "retailer"
    And I go to the retailer_items page
    Then I should see "43210121"
    And I go to the subscription_results page
    And I follow "1234"
    Then I should see "43220120"

