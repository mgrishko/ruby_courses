@javascript
Feature: Add new Base Item
  In order to test adding new Base Items
  As a supplier
  I want to create Base Item

  Scenario: Create publish base_item
    Given "supplier" has gln "1234" and password "1234"
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
    And I fill in "base_item_country" with "China"
    And I fill in hidden_field "base_item_gpc_name" with "Artists Accessories"
    And I wait for 1 second
    And I press "next_button"
    And I wait for 2 seconds
    And I fill in "base_item_packaging_type" with "BX"
    And I fill in "base_item_height" with "1"
    And I fill in "base_item_width" with "1"
    And I fill in "base_item_depth" with "1"
    And I fill in "base_item_gross_weight" with "1"
    And I fill in "base_item_net_weight" with "1"
    And I wait for 1 second
    And I press "next_button"
    And I wait for 1 second
    And I press "base_item_submit" within ".logistics"
    Then 1 base_items should exist

