Feature: Show product
  In order to view company catalog
  Any account member
  Should be able to view product

  Background: Account exists
    Given an activated account
    And that account has a product

  Scenario: Contributor can see the product
    Given an authenticated user with contributor role
    And he is on the products page
    When he follows product link
    Then he should be on the product page
    And he should not see "Edit Product" link within sidebar

  Scenario: Editor can see a lint to edit product
    Given an authenticated user with editor role
    And he is on the product page
    Then he should see "Edit Product" link within sidebar
