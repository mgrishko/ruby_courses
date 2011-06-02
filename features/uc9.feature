@javascript
Feature: Subscription Result generation
  In order to test subscription result generation
  As a supplier
  I want to create and edit product

  Scenario: Create and publish base_item
    Given "supplier" has gln "1234" and password "1234"
    And "retailer" has gln "4321" and password "1234"
    And the following subscriptions exist
      |status|retailer_id|supplier_id|
      |active| 2 | 1 |
    And the following countries exist
      | code | description |
      | RU | Russia |
      | CN | China |
    And the following gpcs exist
    | segment_description | description | code | name |
    | Arts/Crafts/Needlework Supplies |	Artists Painting/Drawing  Supplies |	10001682|	Artists Accessories |
    When I logged in as "supplier"
    And I go to the base_items page
    And I follow "New base_item"
    And I fill in "base_item_gtin" with "1234567"
    And I fill in "base_item_internal_item_id" with "1"
    And I fill in "base_item_brand" with "Brand name"
    And I fill in "base_item_subbrand" with "Subbrand name"
    And I fill in "base_item_functional" with "1"
    And I fill in "base_item_content" with "1"
    And I select "лист" from "base_item_content_uom"
    And I fill in "base_item_item_description" with "some description"
    And I fill in "base_item_manufacturer_gln" with "87987687"
    And I fill in "base_item_manufacturer_name" with "Some manufacturer name"
    And I select "10 %" from "base_item_vat"
    And I fill in "base_item_minimum_durability_from_arrival" with "1"
    And I click element "#base_item_country"
    And I click element "#CN"
    And I follow "country_select"
    And I fill in "base_item_gpc_name" with "Artists Accessories"
    And I press "Дальше"
    And I fill in "base_item_packaging_type" with "AM"
    And I fill in "base_item_height" with "1"
    And I fill in "base_item_width" with "1"
    And I fill in "base_item_depth" with "1"
    And I fill in "base_item_gross_weight" with "1"
    And I fill in "base_item_net_weight" with "1"
    And I press "Дальше"
    And I press "Опубликовать"
    When I logged in as "retailer"
    And I go to the subscription_results page
    Then I should see "1234"
    When I follow "1234"
    Then I should see "1234567"

  Scenario: Edit and publish base_item
    Given "supplier" has gln "1234" and password "1234"
    Given "retailer" has gln "4321" and password "1234"
    And the following subscriptions exist
      |status|retailer_id|supplier_id|
      |active| 2 | 1 |
    And I logged in as "supplier"
    And I have a base_item with gtin "1234567"
    When I go to the base_item page
    And I press "Правка"
    And I follow "править" within "#base_item"
    And I fill in "Any brand" for "base_item_subbrand"
    And I press "Применить"
    And I press "Опубликовать"
    When I logged in as "retailer"
    And I go to the subscription_results page
    Then I should see "1234"
    When I follow "1234"
    Then I should see "1234567"

