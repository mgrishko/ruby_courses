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
    And I press "Правка"
    And I follow "править" within "#base_item"
    And I fill in "Any brand" for "base_item_subbrand"
    And I press "Применить"
    And I press "Опубликовать"
    And I go to the base_item with gtin "7654321" page
    And I press "Правка"
    And I follow "править" within "#base_item"
    And I fill in "Any brand" for "base_item_subbrand"
    And I press "Применить"
    And I press "Опубликовать"


  Scenario: get multiple base_items export as retailer
    When I logged in as "retailer"
    And I follow "Inbox"
    And I wait for 10 second
    And I follow "1234"
    And I confirm action
    And I follow "Акцептовать все"
    And I follow "Received Items"
    And I check "base_items[]"
    And I follow "Export to xls"
    Then I should see "Получить данные в формах ритейлеров"
    And I check "7continent"
    And I press "Экспортировать"
    Then I should receive file ".zip"

  Scenario: get multiple base_items export as supplier
    When I logged in as "supplier"
    And I go to the base_items page
    And I check "base_items[]"
    And I follow "Export to xls"
    Then I should see "Получить данные в формах ритейлеров"
    And I check "7continent"
    And I press "Экспортировать"
    Then I should receive file ".zip"

  Scenario: when no bi checked
    When I logged in as "supplier"
    And I go to the base_items page
    And I follow "Export to xls"
    Then I should not see "Экспортировать"

  Scenario: when no form checked
    When I logged in as "supplier"
    And I go to the base_items page
    And I check "base_items[]"
    And I follow "Export to xls"
    Then I should see "Получить данные в формах ритейлеров"
    And element "#export_button" should be disabled

