Feature: Autocompletion for product form fields
  In order to fill out product forms faster
  An editor
  Should be able to use autocompletion

  Background: Account exists
    Given an activated account
    And that account has a product
    And the product has tags
  
  @javascript @wip
  Scenario: Editor successfully updates a product
    Given an authenticated user with editor role
    And he is on the product page
    When he follows "Edit Product" within sidebar
    Then step1
    Then step2
    Then step3
    Then step2
    And he fills in tags field
    Then he should see the tags autocomplete