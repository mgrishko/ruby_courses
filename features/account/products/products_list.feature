Feature: Products list
  In order to view company products
  An account member
  Should be able to access products list

  Background: Account exists
    Given an activated account

  Scenario: Editor sees welcome box when new account
    Given an authenticated user with editor role
    And he is on the products page
    Then he should see products welcome message:
      """
      This Products screen will show you the list of your products.
      But before we can show your products, you'll need to create the first product.
      """
    And he should see products welcome message:
      """
      Please, click "New" button on the left to get started.
      """
    When he follows "New" within sidemenu
    And he adds a new product
    And he goes to the products page
    Then he should not see products welcome box

  Scenario: Viewer does not see message about new product link
    Given an authenticated user with viewer role
    And he is on the products page
    Then he should see products welcome message
    And he should not see products welcome message:
      """
      Please, click "New" button on the left to get started.
      """

  Scenario: User successfully goes to the company products list
    Given an authenticated user with viewer role
    And he is on the account home page
    When he follows "Products" within topbar
    Then he should be on the products page

  Scenario: User cannot view other company account products
    Given another active account
    And that other account has a product
    Given an authenticated user with viewer role
    When he goes to the products page
    Then he should not see that product in the products list



