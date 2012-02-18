Feature: Product visibility
  In order to restrict access to product info
  An account admin and editor
  Should be able to set a product visibility

  Background: Account exists
    Given an activated account

#  Scenario: Editor successfully restricts visibility during product creation
#    Given an authenticated user with editor role
#    And he is on the new product page
#    When he sets product visibility to private
#    And he submits a new product form
#    Then he should be on the product page
#    And he should see notice message "Product was successfully created."
#    And he should see "Private" within sidebar
#    When he goes to the products page
#    Then he should see "Private" under product link
#
#  Scenario: Editor changes product visibility during update
#    Given that account has a private product
#    And an authenticated user with editor role
#    And he is on the edit product page
#    When he changes product visibility to "Public"
#    And he submits form with updated product
#    Then he should be on the product page
#    And he should see notice message "Product was successfully updated."
#    And he should see "Public" within sidebar
#    When he goes to the products page
#    Then he should not see "Public" under product link