Feature: Account membership management
	In order to control which users have access to an account
	An account admin
	Should be able to manage the account membership
	
	Background:
		Given an authenticated admin user
		And admin user is on the account memberships page
	
	@wip
	Scenario: Admin user views the account users
		Then he should see account users
	
	Scenario: Admin user deletes a user from an account
		When he deletes an account user
		Then he should see notice message "has been deleted from account"
	
	Scenario: Admin user can't delete the account owner from an account
		Then he should not be able to delete the account owner
		
	Scenario: Admin user changes the role of an account user
		When he opens edit user membership page
		And changes the user role
		Then he should see notice message "role has been changed"
	
	Scenario: Admin user changes his role in the account
		When he changes his own role
		Then he should see notice message "role has been changed"
	
	Scenario: Admin user can't change the account owner role
		Then he should not be able to edit the account owner role
