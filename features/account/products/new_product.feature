Feature: New product
  In order to publish company catalog
  An editor
  Should be able to add new products

  Background: Account exists
    Given an activated account

  Scenario: Editor successfully adds a new product
    Given an authenticated user with editor role
    And he is on the products page
    When he follows "New Product" within sidemenu
    And he submits a new product form with following data:
      | Functional name   |
      | Variant           |
      | Brand             |
      | Sub brand         |
      | Manufacturer      |
      | Country of origin |
      #| Short description |
      | Description       |
      | GTIN              |
    Then he should be on the product page
    And he should see notice message "Product was successfully created."
#    And he should see "Version 1" text within sidebar
    When he goes to the products page
    Then he should see that product in the products list

  Scenario: Viewer should not be able to add a new product
    Given an authenticated user with viewer role
    And he is on the products page
    Then he should not see "New Product" link within sidemenu
    When he goes to the new product page
    Then he should see alert message "Not allowed to create a new product."

  Scenario: Editor successfully adds a new product with measurements
    Given an authenticated user with editor role
    And he is on the new product page
    When he enters the following measurements:
      | Depth, mm        |
      | Height, mm       |
      | Width, mm        |
      | Gross weight, g  |
      | Net weight, g    |
      | Net content      |
    And he submits a new product form
    Then he should be on the product page
    And he should see notice message "Product was successfully created."

  Scenario: Editor successfully adds a new product with internal id
    Given an authenticated user with editor role
    And he is on the new product page
    When he enters the following product codes:
      | Internal ID       |
    And he submits a new product form
    Then he should be on the product page
    And he should see notice message "Product was successfully created."

