#Есть Поставщик
#Есть Товар
#Есть Первый Ритейлер
#Есть Второй Ритейлер
#
#1. Заходит Первый Ритейлер
#2. Переход на страничку "Поставщики"
#3. Нажимает на кнопку "Подписаться"
#4. Заходит Второй Ритейлер
#5. Переходит на страничку "Поставщики"
#6. Нажимает на кнопку "Подписаться"
#7. Заходит Поставщик
#8. Переходит на страничку товара
#9. Нажимает кнопку "Правка"
#9.5. Меняет что-нибудь
#10. Ставит флаг "Приватно"
#11. Выбирает Первого Ритейлера из Списка
#12. Нажимает Опубликовать
#13. Заходит Первый Ритейлер
#14. Переходит на вкладку Inbox
#15. Переход по ссылке
#16. Видит измененные данные товара
#16. Заходит Второй Ритейлер
#17. Переходит на вкладку Inbox
#18. Переходит по ссылке
#19. НЕ видит измененные данные товара
#
@javascript
Feature:  Some Base Items can be private
  In order to make private Base Items
  As a retailer can do private data for suppliers
  As a supplier can receive private data
  I want make it possible

  Background:
    Given "supplier" has gln "1234" and password "1234"
    And "retailer" has gln "4321" and password "1234" also
    And "another_retailer" has gln "5678" and password "1234" also
    And "supplier" has a base_item

  Scenario: Supplier with Base Item and Retailers
    Given I logged in as "retailer"
    And go to the suppliers page
    And press "Подписаться"
    And I logged in as "another_retailer"
    And go to the suppliers page
    And press "Подписаться"
    And I logged in as "supplier"
    And I go to the base_item page
    When I press "base_item_submit"
    And I follow "edit_base_item_link"
    And I fill in "base_item_item_description" with "uUi56fgewKJwexmeaYkdewnbxw67Zjedwe"
    And I wait for 1 second
    And I press "Применить"
    And I check "base_item[private]"
    And I follow "add_receivers_from_list"
    And I select "Retailer" from "new_receiver_input2"
    And I press "submit_receiver_button"
    And I wait for 1 second
    And I press "Опубликовать"
    Then I logged in as "retailer"
    And go to the subscription_results page
    And I wait for 1 second
    And I follow "Supplier"
    And I wait for 1 second
    And I should see "uUi56fgewKJwexmeaYkdewnbxw67Zjedwe"
    And I logged in as "another_retailer"
    And go to the subscription_results page
    And I follow "Supplier"
    And I should not see "uUi56fgewKJwexmeaYkdewnbxw67Zjedwe"

