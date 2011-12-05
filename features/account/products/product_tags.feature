Feature: Product tags
  In order to group products
  An account admin and editor
  Should be able to add tags to the product

  Background: Account exists
    Given an activated account

  Scenario: Editor successfully adds a new product with tags
    Given an authenticated user with editor role
    And he is on the new product page
    When he submits a new product form with following data:
      | Name        |
      | Description |
      | Tags        |
    Then he should be on the product page
    And he should see notice message "Product was successfully created."
    And he should see that tags under product name
    When he goes to the products page
    Then he should see that tags under product link

  Scenario: Editor enters tags during product update
    Given that account has a product with tags
    And an authenticated user with editor role
    And he is on the edit product page
    When he edits product tags
    And he submits form with updated product
    Then he should be on the product page
    And he should see notice message "Product was successfully updated."
    And he should see that tags under product name