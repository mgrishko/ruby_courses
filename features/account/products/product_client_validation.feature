Feature: User input is validated on client side
  In order to fill in forms faster
  An account editor
  Should be able to see client side validation

  Background: Account exists
    Given an activated account

  @javascript @wip
  Scenario: Editor successfully adds a new product
    Given an authenticated user with editor role
    And he is on new product page
    #And he submits the new product form
    Then he should see validation error for "Name" untill he enters "ProductName"
    Then show me the page
  