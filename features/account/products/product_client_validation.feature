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
    Then he should not see validation errors in "new_product" form
    And he should see error in "new_product" for "Functional name" if he leaves it empty
    And he should not see error in "new_product" for "Variant" if he leaves it empty
    And he should see error in "new_product" for "Brand" if he leaves it empty
    And he should not see error in "new_product" for "Sub brand" if he leaves it empty
    And he should see error in "new_product" for "Manufacturer" if he leaves it empty
    And he should not see error in "new_product" for "Short description" if he leaves it empty
    And he should not see error in "new_product" for "Description" if he leaves it empty
    And he submits a new product form
    And he should see notice message "Product was successfully created."
