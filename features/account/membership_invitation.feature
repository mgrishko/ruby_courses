Feature: Membership invitation
  In order to get access to an account for other users
  An account admin
  Should be able to invite new account members

  Background: Account admin exists
    Given an activated account
    And an authenticated user with admin role

  Scenario: Admin invites a new user to an account
    Given admin is on the account memberships page
    When he follows "Invite new user" within sidebar
    And he submits the account invitation form with:
      | First name |
      | Last name  |
      | Email |
      | Role  |
    Then he should see notice message "A new membership invitation has been sent"
    When admin goes to the account memberships page
    Then he should see that user
    And a user membership state should be invited

    And user should receive an invitation email
    When he follows membership invitation link
    Then he should be on the accept invitation page
    When he submits the accept invitation form with:
      | First name |
      | Last name  |
      | Password   |
    Then he should be on the company account home page
    And he should see notice message "Welcome on board! You are now signed in."
    And a user membership state should be active

  Scenario: Admin invites an unauthenticated user to an account
    Given an unauthenticated user
    When admin invites that user
    Then user should receive an invitation email
    When he follows membership invitation link
    And he submits valid email and password
    Then he should see notice message "Welcome on board! You are now signed in."

  Scenario: Admin invites an authenticated user to an account
    Given an authenticated user
    When admin invites that user
    Then user should receive an invitation email
    When he follows membership invitation link
    Then he should be on the company account home page
    And he should see notice message "Welcome on board! You are now signed in."

  Scenario: Admin tries to invite an invited user
    Given an invited user with email "invited@email.com"
    When admin tries to invite that user
    Then he should see alert message "User with email invited@email.com is already invited."
    And user should not receive an invitation email
