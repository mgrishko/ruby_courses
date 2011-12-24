Feature: User input is validated on client side
  In order to fill in forms faster
  An account editor
  Should be able to see client side validation

  Background: Account exists
    Given an activated account

  @javascript
  Scenario: Editor successfully adds a new product
    Given an authenticated user with editor role
    And he is on the new product page
    Then he should not see validation errors in new product form
    And he should see validation error for "Functional name" if he leaves it empty
    And he should see validation error for "Brand" if he leaves it empty
    And he should see validation error for "Manufacturer" if he leaves it empty
    And he should see validation error for "Description" if he leaves it empty
    And he submits a new product form
    And he should see notice message "Product was successfully created."
  