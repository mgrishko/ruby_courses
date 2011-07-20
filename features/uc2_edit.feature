@javascript
Feature: Supplier publishes base_item
  In order to test base_item publication
  As a supplier
  I want publish base_item


  Scenario: Do not edit but publish
    Given "supplier" has gln "1234" and password "1234"
    And I logged in as "supplier"
    And I have a base_item
    When I go to the base_item page
    And I follow "edit_base_item_btn"
    And I press "base_item_submit"
    Then I new publication should not occur

  Scenario: Edit and publish
    Given "supplier" has gln "1234" and password "1234"
    And I logged in as "supplier"
    And I have a base_item
    When I go to the base_item page
    And I follow "edit_base_item_btn"
    And I follow "edit_base_item_link" within "#base_item"
    And I fill in "Any brand" for "base_item_subbrand"
    And I press "base_item_submit" within "#step1"
    And I press "base_item_submit" within ".logistics"
    Then I new publication should occur

