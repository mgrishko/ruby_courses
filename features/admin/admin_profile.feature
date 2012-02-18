Feature: Admin edit
  In order to edit admin profile
  An admin
  Should be able to edit admin profile

  Background: Admin exists
    Given an authenticated admin

  Scenario: Admin successfully edits profile
    When the admin tries to access a restricted page
    Then admin should be redirected back to the restricted page
    And he should see next links:
      | link         |
      | Sign out     |
      | Profile      |
      | Account list |
    When he follows "Profile" within topbar
    Then he should be redirected to the admin profile page
    When he submits profile form with current password
    Then he should see notice message "Admin was successfully updated."
    And he follows "Sign out" within topbar
    Then admin should be signed out
    When admin submits valid email and valid password
    Then admin should be signed in

  Scenario: Admin edits profile without current password
    And he is on the admin profile page
    When he submits profile form without current password
    Then admin should see that current password can't be blank

  Scenario: Admin sets new password
    Given he is on the admin profile page
    When he submits profile form with new password
    Then he should be redirected to the admin profile page
    And he should see notice message "Admin was successfully updated."
    And he follows "Sign out" within topbar
    Then he should be redirected to the admin sign in page
    When admin submits email and new password
    Then admin should be signed in