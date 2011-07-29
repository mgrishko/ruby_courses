# Есть Поставщик
# Есть Первый Ритейлер
# Есть Второй Ритейлер
# Есть Товар
#
# 1. Поставщик зашел
# 2. Перешел на страничку с товаром
# 3. Нажал кнопку "Добавить Ярлык"
# 4. Вводит имя тега
# 5. Нажимает Enter
# 6. Тег должен появиться в "списке тегов"
# 6. Нажал кнопку "Добавить Ярлык"
# 7. Вводит имя тега
# 8. Нажимает Enter
# 9. Тег должен появиться в "списке тегов"
# 10. Входит Первый Ритейлер
# 11. Переходит на страничку с товаром
# 12. НЕ видит тегов
# 13. Нажимает кнопку "Добавить Ярлык"
# 14. Вводит имя тега
# 15. Нажимает Enter
# 16. Тег должен появиться в "списке тегов"
# 17. Входит Второй Ритейлер
# 18. Переходит на страничку с товаром
# 19. НЕ видит тегов

@javascript
Feature:  Users can add tags
  In order to add Retailers Attributes
  As a retailer
  I want add retailer attributes
  
  Background:
    Given "supplier" has gln "1234" and password "1234"
    And "retailer" has gln "4321" and password "1234" also
    And "another_retailer" has gln "5678" and password "1234" also
    And "supplier" has a base_item

  Scenario: Users and tags 
    Given I logged in as "supplier"
    And I go to the base_item page
    And I follow "add_tag_link" 
    And I fill in "tag_name" with "tag-1"
    When I press Enter in "tag_name"
    Then I should see "tag-1" within "#tags"
    Given I follow "add_tag_link" 
    And I fill in "tag_name" with "tag-11"
    When I press Enter in "tag_name"
    Then I should see "tag-11" within "#tags"
    Given I logged in as "retailer"
    And I go with "?view=true" to the base_item page
    And I should not see "tag-1" within "#tags"
    And I should not see "tag-11" within "#tags"
    And I follow "add_tag_link" 
    And I fill in "tag_name" with "tag-1"
    When I press Enter in "tag_name"
    Then I should see "tag-1" within "#tags"
    Given I logged in as "another_retailer"
    When I go with "?view=true" to the base_item page
    Then I should not see "tag-1" within "#tags"
    And I should not see "tag-11" within "#tags"
    And 3 clouds should exist
    And 2 tags should exist

  Scenario: User tags autocompletion
    Given I logged in as "supplier"
    And I go to the base_item page
    And I follow "add_tag_link" 
    And I fill in "tag_name" with "tag-1"
    When I press Enter in "tag_name"
    Then I should see "tag-1" within "#tags"
    Given I logged in as "retailer"
    And I go with "?view=true" to the base_item page
    And I follow "add_tag_link"
    And I fill in "tag_name" with "tag-2"
    When I press Enter in "tag_name"
    And I wait for 1 second
    And I follow "add_tag_link"
    And I fill in "tag_name" with "tag"
    Then I should see "tag-2"
    And I should not see "tag-1"
    





