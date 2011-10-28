#Есть Поставщик
#Есть Товар
#Есть Первый Ритейлер
#Есть Второй Ритейлер

#1. Зашел Первый Ритейлер
#2. Перешел на страничку товара
#3. Написал комментарий
#4. Нажал кнопку опубликовать комментарий
#5. Зашел поставщик
#6. Перешел на страничку товара
#7. Нажал ссылку "ответить"
#8. Написал комментарий
#9. Нажал на кнопку "Ответить"
#10. Зашел Первый Ритейлер
#11. Перешел на страничку товара
#12. Увидел комментарий Поставщика
#13. Зашел Второй Ритейлер
#14. Перешел на страничку товара
#15. Не увидел комментарий Первого Ритейлера
#16. Не увидел комментарий Поставщика
@javascript

Feature:  Supplier can reply
  In order to reply for comments
  As a supplier
  I want reply

  Background:
    Given "supplier" has gln "1234" and password "1234"
    And "supplier" has a base_item
    And "retailer" has gln "4321" and password "1234" also
    And "another_retailer" has gln "5678" and password "1234" also

  Scenario: Retailer post comments
    Given I logged in as "retailer"
    And I go with "?view=true" to the base_item page
    And I fill in "comment_content" with "My Personal Comment"
    And I press "comment_submit"
    When I logged in as "supplier"
    And I go to the base_item page
    And I follow "show_comment_form"
    And I fill in "comment_reply" with "Reply for the Personal Comment"
    And I press "reply_submit"
    Then I should see "My Personal Comment" within "#comments"
    And I should see "Reply for the Personal Comment"
    And I logged in as "another_retailer"
    And I go with "?view=true" to the base_item page
    And I should not see "Another comment" within "#comments"
    And I should not see "Reply for the Personal Comment"

