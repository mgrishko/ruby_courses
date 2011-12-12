Feature: Edit product
  In order to update company catalog
  An editor
  Should be able to edit products

  Background: Account exists
    Given an activated account
    And that account has a product
  
  Scenario: Editor successfully updates a product
    Given an authenticated user with editor role
    And he is on the product page
    When he follows "Edit Product" within sidebar
    And he submits form with updated product
    Then he should be on the product page
    And he should see notice message "Product was successfully updated."
    And he should see "Version 1" link within sidebar

  Scenario: Viewer should not be able to update a product
    Given an authenticated user with viewer role
    And he is on the product page
    Then he should not see "Update Product" link within sidebar
    When he goes to the update product page
    Then he should see alert message "Not allowed to update a product."

