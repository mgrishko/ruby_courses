Feature: Autocompletion for product form fields
  In order to fill out product forms faster
  An editor
  Should be able to use autocompletion

  Background: Account exists
    Given an activated account
    And that account has a product
  
  @javascript
  Scenario: Editor successfully updates a product
    Given another product with brand "brand123"
    Given an authenticated user with editor role on edit product page
    And he enters "brand" into "Brand" field and selects "brand123" autocomplete option
    And he submits the product form
    Then he should see product brand "brand123"
  
  @javascript 
  Scenario: Editor successfully updates a product
    Given another product with manufacturer "manufacturer123"
    Given an authenticated user with editor role on edit product page
    And he enters "manufacturer" into "Manufacturer" field and selects "manufacturer123" autocomplete option
    And he submits the product form
    Then he should see product manufacturer "manufacturer123"