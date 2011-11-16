Feature: Account membership management
  In order to control which users have access to an account
  An account admin
  Should be able to manage the account membership
  
  Scenario: Admin user views the account users
    Given account with memberships
    Given admin user is on the account memberships page
    Then he should see account users

  Scenario: Non-admin can't view the account users
    Given account with memberships
	Given an authenticated account user
	Then he should not see account users

  Scenario: Admin user deletes a user from an account
    Given account with memberships
    Given admin user is on the account memberships page
    When he deletes an account user
    Then he should see notice message "was successfully destroyed"

  Scenario: Admin user can't delete the account owner from an account
    Given active account
    Given admin user is on the account memberships page
    Then he should not be able to delete the account owner

  Scenario: Admin user changes the role of an account user
    Given account with memberships
    Given admin user is on the account memberships page
    When he opens edit user membership page
    And changes the user role
    Then he should see notice message "was successfully updated"
  @wip
  Scenario: Admin user changes his role in the account
    Given account with another admin
    Given non owner admin user is on the account memberships page
    When he opens edit user membership page
    And changes the user role
    Then he should be redirected to home page

  Scenario: Admin user can't change the account owner role
    Given account with memberships
    Given non owner admin user is on the account memberships page
    Then he should not be able to edit the account owner role
