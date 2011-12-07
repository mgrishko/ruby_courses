Feature: Admin edit
  In order to edit admin profile
  An admin
  Should be able to edit admin profile

  Background: Admin exists
    Given an authenticated admin

  Scenario: Admin successfully edits profile
    When he goes to the home page
    Then he should see "Sign out", "Profile", "Accounts" links
    When he follows "Profile" within topbar
    Then he should be redirected to the admin profile page
    When he submits admin profile form with current password
    Then he should see notice message "You updated your profile successfully."
    And he follows "Sign out" within topbar
    Then he should be redirected to the admin sign in page
    When admin submits email and password
    Then admin should see notice message "Signed in successfully."

  Scenario: Admin edits profile without current password
    And he is on the admin profile page
    When he submits admin profile form without current password
    Then he should see that current password can't be blank

  Scenario: Admin sets new password
    Given an authenticated user with viewer role
    And he is on the admin profile page
    When he submits admin profile form with new password
    Then he should be redirected to the admin profile page
    And he should see notice message "You updated your profile successfully."
    And he follows "Sign out" within topbar
    Then he should be redirected to the admin sign in page
    When user submits email and new password
    Then user should see notice message "Signed in successfully."
