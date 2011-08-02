@javascript
@wip
Feature: Data export(multiple bi)
  In order to test data to xls export
  As a user
  I want to get exported data

  Background:
    Given "supplier" has gln "1234" and password "1234"
    Given "retailer" has gln "4321" and password "1234"
    And the following subscriptions exist
      |status|retailer_id|supplier_id|
      |active| 2 | 1 |
    And I logged in as "supplier"
    Given I have a base_item with gtin "1234567"
    Given I have a base_item with gtin "7654321"
    And I go to the base_item with gtin "1234567" page
    And I follow "edit_base_item_btn"
    And I follow "edit_base_item_link" within "#base_item"
    And I fill in "Any brand" for "base_item_subbrand"
    And I press "base_item_submit" within "#step1"
    And I press "base_item_submit" within ".logistics"
    And I go to the base_item with gtin "7654321" page
    And I follow "edit_base_item_btn"
    And I follow "edit_base_item_link" within "#base_item"
    And I fill in "Any brand" for "base_item_subbrand"
    And I press "base_item_submit" within "#step1"
    And I press "base_item_submit" within ".logistics"


  Scenario: get multiple base_items export as retailer
    When I logged in as "retailer"
    And I go to the subscription_results page
    And I follow "1234"
    And I confirm action
    And I follow "accept_all"
    And I go to the retailer_items page
    And I check "base_items[]"
    And I follow "show_export_form"
    Then should be visible "export_form_wrapper"
    And I check "7continent"
    And I press "export_button"
#    Then I should receive file

  Scenario: get multiple base_items export as supplier
    When I logged in as "supplier"
    And I go to the base_items page
    And I check "base_items[]"
    And I follow "show_export_form"
    Then should be visible "export_form_wrapper"
    And I check "7continent"
    And I press "export_button"
#    Then I should receive file

  Scenario: when no bi checked
    When I logged in as "supplier"
    And I go to the base_items page
    And I follow "show_export_form"
    Then should not be visible "export_button"

  Scenario: when no form checked
    When I logged in as "supplier"
    And I go to the base_items page
    And I check "base_items[]"
    And I follow "show_export_form"
    Then should be visible "export_form_wrapper"
    And element "#export_button" should be disabled

