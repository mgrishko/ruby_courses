@javascript
Feature: Test packages
  In order to test existing Base Item
  As a supplier
  I want to create, edit and drop valid packaging tree.

  Scenario: Test packages
    Given "supplier" has gln "1234" and password "1234"
    And I logged in as "supplier"
    And I have a base_item
    And  I go to the base_item page
    #When I go to the base_item page
    And I follow "edit_base_item_btn"
    And I press "base_item_submit"
