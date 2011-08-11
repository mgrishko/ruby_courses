
Feature: User has own profile page and can edit it
  In order to test user profiles
  As a user
  I want check and edit user profile

  Background:
    Given "supplier" has gln "1234" and password "1234"
    And "retailer" has gln "5678" and password "1234" also

  Scenario: Supplier edit user profile
    When I logged in as "supplier"
    And I follow "settings_link"
    Then I should see "Supplier" within ".info-wrap"
    When I follow "edit_user_info_link"
    And I fill in "user_name" with "Some name"
    And I fill in "user_email" with "some@email.com"
    And I fill in "user_company_name" with "Some company name"
    And I select "ru" from "user_locale"
    And I fill in "user_contacts" with "Some contacts"
    And I fill in "user_website" with "http://Some.website.com"
    And I press "save_user_info"
    Then user should exist with name: "Some name", company_name: "Some company name", email: "some@email.com", locale: "ru", contacts: "Some contacts", website: "http://Some.website.com"


  Scenario: User should not see other users settings
    When I logged in as "retailer"
    And I go to the users page with "1"
    Then I should not see "1234"

