
Feature: Guest can request invitation.
  In order to test invitation requests
  As a user
  I want request invitation request

  Scenario: Guest requests invitation
    When I go to the new_invitation_request page
    And I fill in "invitation_request_name" with "Some name"
    And I fill in "invitation_request_email" with "some@email.com"
    And I fill in "invitation_request_company_name" with "Some company name"
    And I fill in "invitation_request_notes" with "Some notes"
    And I press "invitation_request_submit"
    Then invitation_request should exist with name: "Some name", company_name: "Some company name", email: "some@email.com", notes: "Some notes", status: "new"

