Feature: Products list
  In order to view company products
  An account member
  Should be able to access products list

  Background: Account exists
    Given an activated account

  Scenario: User successfully goes to the company products list
    Given an authenticated user with viewer role
    And he is on the account home page
    When he follows "Products" within topbar
    Then he should be on the products page

  Scenario: User can not view other company account products
    Given some other account
    And that other account has a product
    Given an authenticated user with viewer role
    When he goes to the products list
    Then he should not see that product in the products list



