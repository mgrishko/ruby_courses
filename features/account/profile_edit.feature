Feature: Edit user
  In order to edit user data
  A user
  Should be able change self account data

  Background: Activated account exists
    Given an activated account

  Scenario: User successfully edits profile
    Given an authenticated user
    When he goes to the home page
    And he follow "Profile"
    Then he should be redirected to the edit profile page
    When he submits profile form with current password
    Then he should be redirected to the edit profile page
    And he should see notice message "You updated your account successfully."
    When user signs out
    When user returns next time
    Then he can successfully sign in with old password

  Scenario: User edits profile without current password
    Given an authenticated user
    And he is on the edit profile page
    When he submits profile form without current password
    #some message

  Scenario: User edits profile without password
    Given an authenticated user
    And he is on the edit profile page
    When he submits profile form with new password
    Then he should be redirected to the edit profile page
    And he should see notice message "You updated your account successfully."
    When user signs out
    When user returns next time
    Then he can successfully sign in with new password
