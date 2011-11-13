Feature: New product
  In order to publish company catalog
  An editor
  Should be able to add new products

  Background: Account exists
    Given an activated account

  Scenario: Editor successfully adds a new product
    Given an authenticated user with an editor role
    And he is on the products page
    When he press "New product" within sidebar
    And he submits a new product form with following data:
      | Name        |
      | Description |
    Then he should see that product on the products page
    And he should see notice message "Product was successfully created."

  Scenario: Viewer should not be able to add a new product
    Given an authenticated user with a viewer role
    And he is on the products page
    Then he should not see "New product" link within sidebar
    When he goes to the new product page
    Then he should see alert message "Not allowed to create new product."

