@javascript

Feature: Supplier shouldn't see other suppliers data
  In order to test visibility of autocompletion data
  As a supplier
  I want to check autocompletion fields

  Background:
    Given "supplier" has gln "1234" and password "1234"
    Given "another_supplier" has gln "4321" and password "1234"
    And the following base_items exist
      |user_id|gtin|brand|subbrand|functional|variant|item_description|manufacturer_name| manufacturer_gln|
      |1|1234567|Coca-cola|explorer|juice|lemon|coca-cola juise lemon|Coca-cola Ltd.| 12345679|
      |2|7654321|Wrangler|frontier|jeans|blue|wrangler jeans blue|Wrangler Inc.|97654321|
    When I logged in as "supplier"
    And I have a base_item with gtin "1234567"
    When I go to the base_item page
    And I follow "edit_base_item_btn"
    And I follow "edit_base_item_link" within "#base_item"


  Scenario: Should see only own fields
    When I fill in "l" for "base_item_brand"
    And I wait for 3 second
    Then I should see "Coca-cola"
    And I should not see "Wrangler"
    When I fill in "o" for "base_item_subbrand"
    And I wait for 3 second
    Then I should see "explorer"
    And I should not see "frontier"
    When I fill in "l" for "base_item_variant"
    And I wait for 3 second
    Then I should see "lemon"
    And I should not see "blue"
    When I fill in "j" for "base_item_functional"
    And I wait for 3 second
    Then I should see "juice"
    And I should not see "jeans"
    When I fill in "a" for "base_item_item_description"
    And I wait for 3 second
    Then I should see "coca-cola juise lemon"
    And I should not see "wrangler jeans blue"
    When I fill in "l" for "base_item_manufacturer_name"
    And I wait for 3 second
    Then I should see "Coca-cola Ltd."
    And I should not see "Wrangler Inc."
    When I fill in "1" for "base_item_manufacturer_gln"
    And I wait for 3 second
    Then I should see "12345679"
    And I should not see "97654321"

