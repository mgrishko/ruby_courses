@javascript
@wip
Feature: Supplier shouldn't see data from drafts in validations or autocompletion
  In order to test drafts data filtration
  As a supplier
  I want to check autocompletion fields and drafts validations
  Background:
    Given "supplier" has gln "1234" and password "1234"
    And the following gpcs exist
      | segment_description | description | code | name |
      | Arts/Crafts/Needlework Supplies |	Artists Painting/Drawing  Supplies |10001682|	Artists Accessories |
      | Arts/Crafts/Needlework Supplies |	Artists Painting/Drawing  Supplies |10000115|	Artists Accessories |

    And the following base_items exist
      |item_id|user_id|gtin|brand|subbrand|functional|variant|item_description|manufacturer_name| manufacturer_gln|status|gpc_code|
      |1|1|11234567|Coca-cola|explorer|juice|lemon|coca-cola juise lemon|Coca-cola Ltd.| 12345679|published|10001682|
      |2|1|7654321|Wrangler|frontier|jeans|blue|wrangler jeans blue|Wrangler Inc.|97654321|draft|10001682|
    And the following items exist
      |status|user_id|
      |add|1|
      |add|1|
    And the following countries exist
      | code | description |
      | RU | Russia |
      | CN | China |
    When I logged in as "supplier"




  Scenario: Should not validate gtin within drafts info
    When I go to the base_items page
    And I follow "new_base_item_link"
    And I wait for 1 second
    And I fill in "base_item_gtin" with "7654321"
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
    And I wait for 1 seconds
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
    Then 3 base_items should exist

  Scenario: Should not see data from drafts
    When I go to the base_item with gtin "11234567" page
    And I follow "edit_base_item_btn"
    And I follow "edit_base_item_link" within "#base_item"
    When I fill in "l" for "base_item_brand"
    And I wait for 1 second
    Then I should see "Coca-cola"
    And I should not see "Wrangler"
    When I fill in "o" for "base_item_subbrand"
    And I wait for 1 second
    Then I should see "explorer"
    And I should not see "frontier"
    When I fill in "l" for "base_item_variant"
    And I wait for 1 second
    Then I should see "lemon"
    And I should not see "blue"
    When I fill in "j" for "base_item_functional"
    And I wait for 1 second
    Then I should see "juice"
    And I should not see "jeans"
    When I fill in "a" for "base_item_item_description"
    And I wait for 1 second
    Then I should see "coca-cola juise lemon"
    And I should not see "wrangler jeans blue"
    When I fill in "l" for "base_item_manufacturer_name"
    And I wait for 1 second
    Then I should see "Coca-cola Ltd."
    And I should not see "Wrangler Inc."
    When I fill in "1" for "base_item_manufacturer_gln"
    And I wait for 1 second
    Then I should see "12345679"
    And I should not see "97654321"

