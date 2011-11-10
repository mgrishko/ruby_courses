Feature: Edit profile
  In order to edit profile data
  A user
  Should be able change profile data

  Background: Activated account exists
    Given an activated account

  Scenario: User successfully edits profile
    Given an authenticated user
    When he goes to the home page
    And he follow "Profile"
    Then he should be redirected to the edit profile page
    When he submits profile form with current password
    Then he should see notice message "You updated your profile successfully."
    And he follow "Sign out"
    Then he should be redirected to the user sign in page
    When user submits email and password
    Then user should see notice message "Signed in successfully."

  Scenario: User edits profile without current password
    Given an authenticated user
    And he is on the edit profile page
    When he submits profile form without current password
    Then he should see that current password can't be blank

  Scenario: User sets new password
    Given an authenticated user
    And he is on the edit profile page
    When he submits profile form with new password
    Then he should be redirected to the edit profile page
    And he should see notice message "You updated your profile successfully."
    And he follow "Sign out"
    Then he should be redirected to the user sign in page
    When user submits email and new password
    Then user should see notice message "Signed in successfully."
