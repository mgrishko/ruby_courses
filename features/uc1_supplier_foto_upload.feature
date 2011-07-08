@javascript
Feature: Supplier foto upload feature
  In order to test upload foto for base_item
  As a supplier
  I want upload foto


  Scenario: Upload image
    Given "supplier" has gln "1234" and password "1234"
    And I logged in as "supplier"
    And I have a base_item
    When I go to the base_item page
    And I follow "Сменить изображение"
    And I attach the test image to "image"
    And I press "Загрузить"
    And I go to the base_item page
    And I wait for 1 seconds
    And I should see new image

