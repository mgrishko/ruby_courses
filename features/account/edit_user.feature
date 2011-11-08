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
    When he submits profile form with current password and with password
    Then he should be redirected to the edit profile page
    And he should see notice message "You updated your account successfully."

  Scenario: User edits profile without current password
    Given an authenticated user
    When he goes to the home page
    And he follow "Profile"
    Then he should be redirected to the edit profile page
    When he submits profile form without current password and with password
    And he should see alert message "You should enter current password."

  Scenario: User edits profile without password
    Given an authenticated user
    When he goes to the home page
    And he follow "Profile"
    Then he should be redirected to the edit profile page
    When he submits profile form with current password and without password
    Then he should be redirected to the edit profile page
    And he should see notice message "You updated your account successfully."
    When user signs out
    And he goes to the user sign in page
    And he fill in "Email" with "email@mail.com"
    And he fill in "Password" with "password"
    Then he should be redirected to the user sign in page
