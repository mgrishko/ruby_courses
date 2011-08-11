Feature: Administrator can accept and decline request.
  In order to test invitation requests
  As a administrator
  I want accept and decline invitations


  Background:
    Given invitation_request exists with name: "Some name", company_name: "Some company name", email: "some@email.com", notes: "Some notes", status: "new"
    And "administrator" has gln "1234" and password "1234"
    Given loaded countries and gpcs

  @javascript
  Scenario: Administrator declines invitation request
    When I logged in as "administrator"
    And I go to the invitation_requests page
    Then I should see "Some name"
    When I click element ".decline"
    Then invitation_request should exist with name: "Some name", company_name: "Some company name", email: "some@email.com", notes: "Some notes", status: "declined"

  @javascript
  Scenario: Administrator accepts invitation request
    When I logged in as "administrator"
    And I go to the invitation_requests page
    Then I should see "Some name"
    When I click element ".accept"
    Then user should exist with name: "Some name", email: "some@email.com", company_name: "Some company name"
    And invitation_request should exist with name: "Some name", company_name: "Some company name", email: "some@email.com", notes: "Some notes"
    And I wait for 20 seconds
    And 10 base_items should exist with user_id: "2"
    And 1 email should be delivered to "some@email.com"

