@javascript
Feature: Data export(single bi)
  In order to test data to xls export
  As a user
  I want to get exported data

  Background:
    Given "supplier" has gln "1234" and password "1234"
    Given "retailer" has gln "4321" and password "1234"
    And the following subscriptions exist
      |status|retailer_id|supplier_id|
      |active| 3 | 2 |
    And I logged in as "supplier"
    Given I have a base_item with gtin "1234567"

  Scenario: get single base_item export as retailer
    When I logged in as "retailer"
    And I go with "?view=true" to the base_item page
    And I follow "export_link"
    And I wait for 1 second
    Then should be visible "export_form_wrapper"
    And I check "7continent"
    And I press "export_one"
#    Then I should receive file

  Scenario: get single base_item export as supplier
    When I logged in as "supplier"
    And I go to the base_item page
    And I follow "export_link"
    And I wait for 1 second
    Then should be visible "export_form_wrapper"
    And I check "7continent"
    And I press "export_one"
    # Then I should receive file ".zip"
#    Then I should receive file

  Scenario: get single base_item export as supplier
    When I logged in as "supplier"
    And I go to the base_item page
    And I follow "export_link"
    And I wait for 1 second
    Then should be visible "export_form_wrapper"
    And element "#export_one" should be disabled

  Scenario: supplier should not see export button/or button should be disabled when editing base_item
    When I logged in as "supplier"
    And I go to the base_item page
    And I follow "edit_base_item_btn"
    Then should not be visible "export_link"

