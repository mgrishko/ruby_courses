Feature: Delete product
  In order to keep company catalog up to date
  An editor
  Should be able to delete products

  Background: Account exists
    Given an activated account
    And that account has a product

  Scenario: Editor successfully deletes a product
    Given an authenticated user with editor role
    And he is on the edit product page
    When he follows "Delete product" within sidemenu
    Then he should be on the products page
    And he should see notice message "Product was successfully deleted."
    And he should not see that product in the products list

  Scenario: Viewer should not be able to delete a product
    Given an authenticated user with viewer role
    And he is on the product page
    Then he should not see "Delete product" link within sidemenu

