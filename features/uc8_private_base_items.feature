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
@wip
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
    And I click element ".subscribe"
    And I logged in as "another_retailer"
    And go to the suppliers page
    And I click element ".subscribe"
    And I logged in as "supplier"
    And I go to the base_item page
    And I follow "edit_base_item_btn"
    And I follow "edit_base_item_link"
    And I fill in "base_item_item_description" with "uUi56fgewKJwexmeaY"
    And I wait for 1 seconds
    And I press "base_item_submit" within "#step1"
    And I click element ".rb-companies"
    And I click element "#retailer_label"
    And I wait for 1 seconds
    And I follow "Retailer"
    And I follow "retailer_select_btn"
    And I fill in hidden_field "receiver_gln" with "4321"
    And I click element ".plus-btn"
    And I wait for 1 second
    And I press "base_item_submit" within ".logistics"
    Then I logged in as "retailer"
    And go to the subscription_results page
    And I wait for 1 second
    And I follow "1234"
    And I wait for 1 second
    And I should see "uUi56fgewKJwexmeaY"
    And I logged in as "another_retailer"
    And go to the subscription_results page

    And I wait for 10 seconds
    And I follow "1234"
    And I should not see "uUi56fgewKJwexmeaY"

