@javascript
@wip
Feature: Subscription Result generation
  In order to test subscription result generation
  As a supplier
  I want to create and edit product

  Scenario: Create base_item
    Given "supplier" has gln "1234" and password "1234"
    And "retailer" has gln "4321" and password "1234"
    And the following countries exist:
      | code | description|
      | RU | Russia |
      | CN | China |
    And I have a base_item
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
    And I click element "#countries_results.inline ul li#RU"
    And I fill in "base_item_country" with "RU"
    And I fill in "base_item_gpc_name" with "Camping Cooking/Drinking/Eating Equipment Other"

    And I press "Дальше"
    And I wait for 5 seconds


#    Gpc code can't be blank
#    Gpc name can't be blank
#    Country of origin code can't be blank

