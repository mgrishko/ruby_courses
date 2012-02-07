Feature: Membership invitation
  In order to get access to an account for other users
  An account admin
  Should be able to invite new account members

  Background: Account admin exists
    Given an activated account

  Scenario: Admin invites a new user to an account
    Given an authenticated user with admin role
    And admin is on the account memberships page
    When he follows "Invite a new member" within sidemenu
    And he submits the account invitation form with:
      | First name |
      | Last name  |
      | Email |
      | Role  |
      | Invitation note |
    Then he should see notice message "A new membership invitation has been sent"
    When admin goes to the account memberships page
    Then he should see that user membership

    Then user should receive an invitation email with password
    And he follows membership invitation link
    And he submits the valid email and password
    Then he should be on the company account home page

  Scenario: Admin invites an unauthenticated user to an account
    Given an unauthenticated user
    When admin invites that user
    Then user should receive an invitation email without password
    When he follows membership invitation link
    And he submits the valid email and password
    Then he should be on the company account home page

  Scenario: Admin invites an authenticated user to an account
    Given an authenticated user
    When admin invites that user
    Then user should receive an invitation email without password
    When he follows membership invitation link
    Then he should be on the company account home page

  Scenario: Admin tries to invite an invited user
    Given user with an account membership
    And an authenticated user with admin role
    And he is on the new membership page
    When admin tries to invite that user
    Then he should be on the redisplayed new membership page
    And he should see that email is already invited
