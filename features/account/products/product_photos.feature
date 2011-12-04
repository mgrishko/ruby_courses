Feature: Product photos
  In order to show product photos
  An editor
  Should be able to manage product photos

  Background: Account exists
    Given an activated account

  @javascript
  Scenario: Editor successfully adds new product photo
    Given that account has a product
    And an authenticated user with editor role
    And he is on the edit product page
    When he clicks "Upload photo" within sidebar
    And he attaches the product photo
#    Then he should see notice message "Photo was successfully uploaded"
#    And he should be on the edit product page
#    And he should see that photo within sidebar

  @javascript
  Scenario: Editor can delete product photo
    Given that account has a product with photo
    And an authenticated user with editor role
    And he is on the edit product page
    When he clicks "Delete photo" within sidebar
    Then he should see notice message "Photo was successfully deleted"
    And he should be on the edit product page
    And he should see missing photo within sidebar

  @wip
  Scenario Outline: User without editor rights can not manage photos
    Given that account has a product <photo> photo
    And an authenticated user with <role> role
    And he is on the edit product page
    Then he should not see "<link>" link within sidebar
    Examples:
      | photo   | role        | link         |
      | without | contributor | Upload photo |
      | without | viewer      | Upload photo |
      | with    | contributor | Delete photo |
      | with    | viewer      | Delete photo |
