Feature: Events feature
  In order to track changes in products
  An user
  Should be able to see the log of events

  Background: Account exists
    Given an activated account
  
  Scenario: Editor sees a new event when he adds a new product
    Given an authenticated user with editor role
    When he adds a new product
    Then he should see "Product created" comment on the product page
    When he goes to the home page
    Then he should see "New" event

  Scenario: Editor sees "Updated by" comment when he updates a product
    Given that account has a product
    And an authenticated user with editor role
    When he updates the product
    Then he should see "Product updated" comment on the product page
    And he cannot delete this comment
    When he goes to the home page
    Then he should see "Update" event
  
  Scenario: Editor sees "Deleted by" event when he deletes a product
    Given that account has a product
    And an authenticated user with editor role
    When he deletes the product
    And he goes to the home page
    Then he should see "Deleted" event
  
  @javascript
  Scenario: Editor sees "Commented by" event when he adds a comment
    Given that account has a product
    And an authenticated user with editor role
    When he adds a comment to the product
    And he follows Dashboard link
    Then he should see "Comment" event
    
  @javascript @wip
  Scenario: Editor deletes a product photo
    Given that account has a product with photo
    And an authenticated user with editor role
    When he deletes the product photo
    And he follows Dashboard link
    Then he should see "Image" event