@javascript
Feature: Supplier events
  In order to test events generation
  As a supplier
  I want to cause events


  Scenario: Make event after comment
    Given "supplier" has gln "1234" and password "1234"
    And I logged in as "supplier"
    And I have a base_item
    When I go to the base_item page
    And I fill in "New Comment" for "comment_content"
    And I press "Добавить комментарий"
    And I go to the events page
    Then I should see "Comment" within ".event-comment"

  Scenario: Make event after publish
    Given "supplier" has gln "1234" and password "1234"
    And I logged in as "supplier"
    And I have a base_item
    When I go to the base_item page
    And I press "Правка"
    And I follow "править" within "#base_item"
    And I fill in "Any brand" for "base_item_subbrand"
    And I press "Применить"
    And I press "Опубликовать"
    And I go to the events page
    Then I should see "BaseItem" within ".event-baseitem"

