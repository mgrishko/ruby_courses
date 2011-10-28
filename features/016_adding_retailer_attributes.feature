#Есть Поставщик
#Есть Первый Ритейлер
#Есть Второй Ритейлер
#Есть Товар

#1. Зашел Ритейлер
#2. Перешел на страничку товара
#3. Нажимает кнопку "Добавить Данные"
#4. Вносит данные
#5. Нажимает кнопку "Сохранить"
#6. Должны появиться эти данные на странице
#7. Перешел на страничку товара
#8. Должны быть видны добавленные данные
#9. Зашел Второй Ритейлер
#10. Перешел на страничку товара
#11. Не видит данные Первого Ритейлера
#12. Нажимает кнопку "Добавить Данные"
#13. Вносит данные
#14. Нажимает кнопку Сохранить
#15. Должны быть видны добавленные данные
@javascript
Feature:  Supplier can reply
  In order to reply for comments
  As a supplier
  I want reply

  Background:
    Given "supplier" has gln "1234" and password "1234"
    And "retailer" has gln "4321" and password "1234" also
    And "another_retailer" has gln "5678" and password "1234" also
    And "supplier" has a base_item

  Scenario: Retailer add Retailer Attributes
    Given I logged in as "retailer"
    And I go with "?view=true" to the base_item page
    And I follow "add_retailer_attribute"
    And I fill in the following:
      | retailer_attribute_retailer_article_id | 998877 |
      | retailer_attribute_retailer_classification | ret-attr-2 |
      | retailer_attribute_retailer_item_description | ret-attr-3 |
      | retailer_attribute_retailer_comment | ret-attr-4 |
    When I press "retailer_attribute_submit"
    Then I should see "998877" within "#retailer_attributes"
    And I should see "ret-attr-2" within "#retailer_attributes"
    And I should see "ret-attr-3" within "#retailer_attributes"
    And I should see "ret-attr-4" within "#retailer_attributes"
    When I go with "?view=true" to the base_item page
    Then I should see "998877" within "#retailer_attributes"
    And I should see "ret-attr-2" within "#retailer_attributes"
    And I should see "ret-attr-3" within "#retailer_attributes"
    And I should see "ret-attr-4" within "#retailer_attributes"
    When I logged in as "another_retailer"
    And I go with "?view=true" to the base_item page
    Then I should not see "998877" within "#retailer_attributes"
    And I should not see "ret-attr-2" within "#retailer_attributes"
    And I should not see "ret-attr-3" within "#retailer_attributes"
    And I should not see "ret-attr-4" within "#retailer_attributes"
    When I follow "add_retailer_attribute"
    And I fill in the following:
      | retailer_attribute_retailer_article_id | 9989877 |
      | retailer_attribute_retailer_classification | ret-attr-12 |
      | retailer_attribute_retailer_item_description | ret-attr-13 |
      | retailer_attribute_retailer_comment | ret-attr-14 |
    When I press "retailer_attribute_submit"
    Then I should see "9989877" within "#retailer_attributes"
    And I should see "ret-attr-12" within "#retailer_attributes"
    And I should see "ret-attr-13" within "#retailer_attributes"
    And I should see "ret-attr-14" within "#retailer_attributes"






