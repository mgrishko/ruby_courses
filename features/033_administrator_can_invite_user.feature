Feature: Administrator invite user.
  In order to test invitation requests
  As a administrator
  I want invite user


  Background:
    Given "administrator" has gln "1234" and password "1234"
    Given loaded countries and gpcs

  @javascript
  Scenario: Administrator accepts invitation request
    When I logged in as "administrator"
    And I go to the invitation_requests page
    And I follow "show_add_user_link"
    And I fill in "user_name" with "Some name"
    And I fill in "user_email" with "some@mail.com"
    And I press "user_submit"
    Then user should exist with name: "Some name", email: "some@mail.com"
    And I wait for 20 seconds
    And 10 base_items should exist with user_id: "2"
    And 1 email should be delivered to "some@mail.com"

