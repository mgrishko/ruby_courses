Feature: Products pagination
  In order to view a lot of products
  A user
  Should be able to paginate products

  Background: Account has products
    Given an activated account
    And an authenticated user with viewer role
    And that account has 20 products

  Scenario: User sees limited results
    Given user is on the products page
    Then show me the page
    Then he should see "Variant 6" product
    And he should not see "Variant 7" product

  @w
  Scenario: User appends new products to the page
    Given user is on the products page
    Then he should see 6 products
    When he follows "More products" within products
    Then he should see 12 products
    When he follows "More products" within products
    Then he should see 18 products
    When he follows "More products" within products
    Then he should see 20 products