Feature: Account membership management
  In order to control which users have access to an account
  An account admin
  Should be able to manage the account membership

  Background:
    Given account with memberships

  @wip
  Scenario: Admin user views the account users
    Given admin user is on the account memberships page
    Then he should see account users

  @wip
  Scenario: Non-admin can't view the account users
	Given an authenticated account user
	Then he should not see account users

  Scenario: Admin user deletes a user from an account
    Given admin user is on the account memberships page
    When he deletes an account user
    Then he should see notice message "has been deleted from account"

  Scenario: Admin user can't delete the account owner from an account
    Given admin user is on the account memberships page
    Then he should not be able to delete the account owner

  Scenario: Admin user changes the role of an account user
    Given admin user is on the account memberships page
    When he opens edit user membership page
    And changes the user role
    Then he should see notice message "role has been changed"

  Scenario: Admin user changes his role in the account
    Given admin user is on the account memberships page 
    When he changes his own role
    Then he should see notice message "role has been changed"

  Scenario: Admin user can't change the account owner role
    Given admin user is on the account memberships page
    Then he should not be able to edit the account owner role
