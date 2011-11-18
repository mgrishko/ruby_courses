Feature: Account membership management
  In order to control which users have access to an account
  An account admin
  Should be able to manage the account membership
  
  Scenario: Admin user navigate to account memberships
    Given account with memberships
    And an authenticated user with admin role
    And he is on the account home page
    When he navigates to the account memberships page
    Then he should see account users

  Scenario: Non-admin can't view the account users
    Given account with memberships
  	And an authenticated user with editor role
	Then he should not see account users menu link
    When he tries to visit account memberships page
    Then he should see alert message "not authorized"

  Scenario: Admin user deletes a user from an account
    Given account with memberships
    And an authenticated user with admin role
    And he is on the account memberships page
    When he deletes an account user
    Then he should see notice message "was successfully deleted"

  Scenario: Admin user can't delete the account owner from an account
    Given active account
    And an authenticated user with admin role
    And he is on the account memberships page
    Then he should not be able to delete the account owner

  Scenario: Admin user changes the role of an account user
    Given account with memberships
    And an authenticated user with admin role
    And he is on the account memberships page
    When he opens edit user membership page
    And changes the user role
    Then he should see notice message "was successfully updated"

  Scenario: Admin user changes his role in the account
    Given account with another admin
    And an authenticated user with admin role
    And he is on the edit his own membership page
    And changes the user role
    Then he should be redirected to home page

  Scenario: Admin user can't change the account owner role
    Given account with memberships
    And an authenticated user with admin role
    And he is on the account memberships page
    Then he should not be able to edit the account owner role
