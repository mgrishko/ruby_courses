Feature: Product filters
  In order to work with large product number
  A user
  Should be able to filter products

  Background: Account exists
    Given an activated account
    And that account has the following products:
      | variant    | brand     | manufacturer |
      | strawberry | Danone    | Metro C&C    |
      | light      | Coca-Cola | Coca-Cola Co |

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
    Examples:
      | filter        | option       | visible    | invisible  |
      | Brands        | Danone       | strawberry | light      |
      | Manufacturers | Coca-Cola Co | light      | strawberry |

