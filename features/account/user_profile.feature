Feature: Edit profile
  In order to edit user profile data
  A user
  Should be able change profile data

  Background: Activated account exists
    Given an activated account

  Scenario: User successfully edits profile
    Given an authenticated user with viewer role
    When he goes to the home page
    And he follows "Profile" within topbar
    Then he should be redirected to the user profile page
    When he submits profile form with current password
    Then he should see notice message "You updated your profile successfully."
    And he follows "Sign out" within topbar
    Then he should be redirected to the user sign in page
    When user submits email and password
    Then user should be signed in

  Scenario: User edits profile without current password
    Given an authenticated user with viewer role
    And he is on the user profile page
    When he submits profile form without current password
    Then user should see that current password can't be blank

  Scenario: User sets new password
    Given an authenticated user with viewer role
    And he is on the user profile page
    When he submits profile form with new password
    Then he should be redirected to the user profile page
    And he should see notice message "You updated your profile successfully."
    And he follows "Sign out" within topbar
    Then he should be redirected to the user sign in page
    When user submits email and new password
    Then user should be signed in

  @javascript
  Scenario: Authenticated user successfully edits profile
    Given an authenticated user with viewer role
    And he is on the user profile page
    When he check checkbox "Show password"
    Then he should see filled password
    And he uncheck checkbox "Show password"
    Then he should not see filled password
    Then he should not see validation errors on the page
    And he should see an error for "First name" text field if it is empty
    And he should see an error for "Last name" text field if it is empty
    And he should see an error for "Email" text field if it is empty
    And he should see an error for "Time zone" select field if it is empty
