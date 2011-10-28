#1. Пользователь вошел
#2. Открывает страничку товара
#3. В поле "Комментарии" вводит текст комментария
#4. Нажимает кнопку "Опубликовать"
#5. Комментарий должен появиться в списке комментариев
@javascript
Feature: User can post comments
  In order to post comments
  As a user
  I want post comments

  Background:
    Given "supplier" has gln "1234" and password "1234"
    And "retailer" has gln "4321" and password "1234" also
    And "another_retailer" has gln "5678" and password "1234" also


  Scenario: Supplier post comments
    Given I logged in as "supplier"
    And I have a base_item
    When I go to the base_item page
    And I fill in "comment_content" with "Very Long comment-comment and commemt again"
    And I press "comment_submit"
    Then I should see "Very Long comment-comment and commemt again" within "#comments"

  Scenario: Supplier and Retailer post comments
    Given I logged in as "supplier"
    And I have a base_item
    And I go to the base_item page
    And I fill in "comment_content" with "Very Long comment-comment and commemt again"
    And I press "comment_submit"
    And I logged in as "retailer"
    When I go with "?view=true" to the base_item page
    And I fill in "comment_content" with "Another comment"
    And I press "comment_submit"
    Then I should see "Another comment" within "#comments"
    And I should see "Very Long comment-comment and commemt again" within "#comments"

  Scenario: Retailer and Another Retailer post comments, Supplier can see all, Retailers can see only own
    Given I logged in as "supplier"
    And I have a base_item
    And I logged in as "retailer"
    And I go with "?view=true" to the base_item page
    And I fill in "comment_content" with "First_Retailer Comment"
    And I press "comment_submit"
    When I logged in as "another_retailer"
    And I go with "?view=true" to the base_item page
    And I fill in "comment_content" with "Second_Retailer Comment"
    And I press "comment_submit"
    Then I should see "Second_Retailer Comment" within "#comments"
    And I should not see "First_Retailer Comment" within "#comments"
    And I logged in as "supplier"
    And I go to the base_item page
    And I should see "Second_Retailer Comment" within "#comments"
    And I should see "First_Retailer Comment" within "#comments"












