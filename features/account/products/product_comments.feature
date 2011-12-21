Feature: Product comments
  In order to get feedback about product from colleagues
  An account admin, editor and contributor
  Should be able to add comments to the product

  Background: Account exists
    Given an activated account
    And that account has a product with comments

  Scenario: Editor successfully adds a new product with comment
    Given an authenticated user with editor role
    And he is on the new product page
    When he submits a new product form with comment
    Then he should be on the product page
    And he should see notice message "Product was successfully created."
    And he should see that comment on the top of comments

  Scenario: Editor enters a comment during product update
    Given an authenticated user with editor role
    And he is on the edit product page
    When he enters a comment to the product
    And he submits form with updated product
    Then he should be on the product page
    And he should see notice message "Product was successfully updated."
    And he should see that comment on the top of comments

  @javascript
  Scenario: Contributor adds a comment to the product and deletes it
    Given an authenticated user with contributor role
    And he is on the product page
    When he submits a comment to the product
    Then he should be on the product page
    And he should see that comment on the top of comments
    When he deletes that comment
    Then he should not see that comment on the top of comments

  Scenario: Viewer cannot add comments
    Given an authenticated user with viewer role
    And he is on the product page
    Then he should see product comments
    And he should not see new comment form

  @javascript
  Scenario: Contributor tries to add blank comment
    Given an authenticated user with contributor role
    And he is on the product page
    When he submits a blank comment to the product
    Then he should be on the product page
    And he should see that comment body can't be blank