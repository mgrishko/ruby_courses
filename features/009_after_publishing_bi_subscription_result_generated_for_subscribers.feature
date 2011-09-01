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
    And I follow "new_base_item_link"
    And I wait for 1 second
    And I fill in "base_item_gtin" with "1234567"
    And I fill in "base_item_internal_item_id" with "1"
    And I fill in "base_item_brand" with "Brand name"
    And I fill in "base_item_subbrand" with "Subbrand name"
    And I fill in "base_item_functional" with "1"
    And I fill in "base_item_content" with "1"
    And I fill in hidden_field "base_item_content_uom" with "LTR"
    And I fill in "base_item_item_description" with "uUi56fgewKJwexmeaY"
    And I fill in "base_item_manufacturer_gln" with "87987687"
    And I fill in "base_item_manufacturer_name" with "Some manufacturer name"
    And I fill in hidden_field "base_item_vat" with "57"
    And I fill in "base_item_minimum_durability_from_arrival" with "1"
    And I fill in hidden_field "base_item_country_of_origin_code" with "CN"
    And I fill in "base_item_country" with "China"
    And I fill in hidden_field "base_item_gpc_name" with "Artists Accessories"
    And I wait for 1 second
    And I press "next_button"
    And I wait for 2 seconds
    And I fill in hidden_field "base_item_packaging_name" with "Box"
    And I fill in "base_item_height" with "1"
    And I fill in "base_item_width" with "1"
    And I fill in "base_item_depth" with "1"
    And I fill in "base_item_gross_weight" with "1"
    And I fill in "base_item_net_weight" with "1"
    And I wait for 1 second
    And I press "next_button"
    And I wait for 1 second
    And I press "base_item_submit" within ".logistics"
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
    And I follow "edit_base_item_btn"
    And I follow "edit_base_item_link" within "#base_item"
    And I fill in "Any brand" for "base_item_subbrand"
    And I press "base_item_submit" within "#step1"
    And I press "base_item_submit" within ".logistics"
    And I logged in as "retailer"
    And I go to the subscription_results page
    Then I should see "1234"
    When I follow "1234"
    Then I should see "1234567"

