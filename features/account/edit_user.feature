Feature: Edit user
  In order to edit user data
  A user
  Should be able change self account data

  Background: Activated account exists
    Given an activated account

  Scenario: User edit account data
    Given an authenticated user
    When he goes to the home page
    And he follow "Profile"
    Then he should be redirected to the edit profile page
    #And he is on the user edit page
    When he fills out the sign up form with following personal data:
      | First name       |
      | Last name        |
      | Email            |
      | Password         |
      | Time zone        |
      | Locale           |
      | Current password |
    And he submits the edit form
    Then he should be redirected to the edit profile page
    And he should see notice message "You update profile"

  Scenario: User edit account data without confirmation
    Given an authenticated user
    When he goes to the home page
    And he follow "Profile"
    Then he should be redirected to the edit profile page
    #And he is on the user edit page
    When he fills out the sign up form with following personal data:
      | First name       |
      | Last name        |
      | Email            |
      | Password         |
      | Time zone        |
      | Locale           |
    And he submits the edit form
    Then he should be redirected to the edit profile page
    And he should see alert message "You should enter current password."
