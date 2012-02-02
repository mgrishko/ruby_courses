Feature: Product client side validation
  In order to fill in forms faster
  An account editor
  Should be able to see client side validation

  Background: Account exists
    Given an activated account

  @javascript
  Scenario: Editor successfully adds a new product
    Given an authenticated user with editor role
    And he is on the new product page

    Then he should not see validation errors on the page
    And he should see validation error for "Functional name" if he leaves it empty
    And he should not see validation error for "Variant" if he leaves it empty
    And he should see validation error for "Brand" if he leaves it empty
    And he should not see validation error for "Sub brand" if he leaves it empty
    And he should see validation error for "Manufacturer" if he leaves it empty
    #And he should not see validation error for "Short description" if he leaves it empty
    And he should not see validation error for "Description" if he leaves it empty
    
    # Dimensions
    And he should not see validation error for "Width, mm; Height, mm; Depth, mm" if he leaves it empty
    And he should see validation error "can't be blank" for "Depth, mm; Height, mm" if he fills in "Width, mm" with "2"
    And he should not see validation error for "Width, mm; Height, mm; Depth, mm" if he leaves it empty
    And he should see validation error "can't be blank" for "Width, mm; Height, mm" if he fills in "Depth, mm" with "2"
    And he should not see validation error for "Width, mm; Height, mm; Depth, mm" if he leaves it empty
    And he should see validation error "can't be blank" for "Width, mm; Depth, mm" if he fills in "Height, mm" with "2"
    And he should not see validation error for "Width, mm; Height, mm; Depth, mm" if he leaves it empty
    And he should not see validation error "can't be blank" for "Width, mm; Height, mm; Depth, mm" if he fills it with "3"
    
    # Weights
    And he should not see validation error for "Gross weight, g; Net weight;" if he leaves it empty
    And he should not see validation error "can't be blank" for "Gross weight, g" if he fills it with "3"
    And he should not see validation error "can't be blank" for "Net weight, g" if he fills it with "2"
    And he should see validation error "can't be blank" for "Gross weight, g" if he fills it with ""
    And he should not see validation error "can't be blank" for "Net weight, g" if he fills it with ""
    And he should see validation error "can't be greater then gross weight" for "Net weight, g" if he fills it with "3"
    And he should see validation error "can't be blank" for "Gross weight, g" if he fills in "Net weight, g" with "2"
    And he should not see validation error "can't be blank" for "Gross weight, g" if he fills it with "4"
    And he should not see validation error "can't be greater then gross weight" for "Net weight, g" if he fills it with "3"
    
    # GTIN
    And he should not see validation error for "GTIN" if he leaves it empty
    And he should see validation error "is not a valid GTIN format" for "GTIN" if he fills it with "6291041500212"
    And he should not see validation error "is not a valid GTIN format" for "GTIN" if he fills it with "6291041500213"
    And he should not see validation error for "GTIN" if he leaves it empty
    
    And he submits a new product form
    And he should see notice message "Product was successfully created."
    