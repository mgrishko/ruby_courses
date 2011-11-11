Feature: Account membership management
	In order to control which users have access to an account
	An account admin
	Should be able to manage the account membership
	
	@wip
	Scenario: Account admin views the account members
		Given an authenticated account admin
		When account admin opens "Account Settings"
		Then account admin should see the list of account members
	
	Scenario: Account admin removes a user from an account
		Given an authenticated account admin
		When account admin opens "Account Settings"
		Then account admin should see "Some User"
		When account admin follows "Remove" link next to "Some User"
		Then account admin should not see "Some User"
		
	Scenario: Account admin changes the role of a member
		Given an authenticated account admin
		When account admin opens "Account Settings"
		Then account admin should see that "Some User" has "Viewer" role
		When account admin follows "Change Role" link next to "Some User"
		Then account admin should see "Change Some User Role"
		When account admin changes role from "Viewer" to "Editor"
		Then account admin should see that "Some User" has "Editor" role
	
	Scenario: Account admin changes his role in the account
		Given an authenticated account admin
		When account admin opens "Account Settings"
		Then account admin should see that "Account Admin" has "Administrator" role
		When account admin follows "Change Role" link next to "Account Admin"
		Then account admin should see "Change Account Admin Role"
		When account admin changes role from "Administrator" to "Viewer"
		Then account admin should be redirected to the home page
	
	Scenario: Account admin can't change the role of the account owner
		Given an authenticated account admin
		When account admin opens "Account Settings"
		Then account admin should see that "Account Owner" has "Administrator" role
		And account admin should not see "Change role" next to "Account Owner"
