Feature: Product filters
  In order to work with large product number
  A user
  Should be able to filter products

  Background: Account exists
    Given an activated account
    And that account has the following products:
      | variant    | brand     | manufacturer | functional_name |
      | strawberry | Danone    | Metro C&C    | Milk            |
      | light      | Coca-Cola | Coca-Cola Co | Soft drink      |

  @javascript
  Scenario Outline: Viewer successfully filters products
    Given an authenticated user with viewer role
    And he is on the products page
    Then he should see "strawberry" product
    Then he should see "light" product
    When he follows "<filter>" within sidemenu
    And he follows "<option>" within submenu
    Then he should see "<visible>" product
    And he should not see "<invisible>" product
    When he follows "All products" within sidemenu
    Then he should see "strawberry" product
    Then he should see "light" product
  Examples:
    | filter        | option       | visible    | invisible  |
    | Brands        | Danone       | strawberry | light      |
    | Manufacturers | Coca-Cola Co | light      | strawberry |
    | Functionals   | Milk         | strawberry | light      |

  @javascript
  Scenario Outline: User can not view other account filter options
    Given another active account
    And that another account has the following products:
      | brand | manufacturer | functional_name |
      | Pepsi | PepsiCo      | Beer            |
    Given an authenticated user with viewer role
    And he is on the products page
    When he follows "<filter>" within sidemenu
    Then he should see "<account>" filter option
    And he should not see "<other account>" filter option
  Examples:
    | filter        | account      | other account |
    | Brands        | Coca-Cola    | Pepsi         |
    | Manufacturers | Coca-Cola Co | PepsiCo       |
    | Functionals   | Soft drink   | Beer          |

