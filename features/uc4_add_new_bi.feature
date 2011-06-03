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
    And I follow "New base_item"
    And I wait for 1 second
    And I fill in "base_item_gtin" with "1234567"
    And I fill in "base_item_internal_item_id" with "1"
    And I fill in "base_item_brand" with "Brand name"
    And I fill in "base_item_subbrand" with "Subbrand name"
    And I fill in "base_item_functional" with "1"
    And I fill in "base_item_content" with "1"
    And I select "лист" from "base_item_content_uom"
    And I fill in "base_item_manufacturer_gln" with "87987687"
    And I fill in "base_item_manufacturer_name" with "Some manufacturer name"
    And I select "10 %" from "base_item_vat"
    And I fill in "base_item_minimum_durability_from_arrival" with "1"
    And I click element "#base_item_country"
    And I click element "#CN"
    And I follow "country_select"
    And I fill in "base_item_gpc_name" with "Artists Accessories"
    And I wait for 1 second
    And I press "Дальше"
    And I wait for 1 second
    And I fill in "base_item_packaging_type" with "AM"
    And I fill in "base_item_height" with "1"
    And I fill in "base_item_width" with "1"
    And I fill in "base_item_depth" with "1"
    And I fill in "base_item_gross_weight" with "1"
    And I fill in "base_item_net_weight" with "1"
    And I wait for 1 second
    And I press "Дальше"
    And I wait for 1 second
    And I press "Опубликовать"
    Then 1 base_items should exist

