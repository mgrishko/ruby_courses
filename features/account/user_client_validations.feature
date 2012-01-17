@javascript
Feature: User main forms input must be validate on client side
  In order to filling forms faster
  An non-registered and later authenticated user
  Should be able to see cliend side validation

  Scenario: Non registered user sign up a new company account
    Given company representative is on the new account sign up page
    Then he should not see validation errors in "user_new" form
    And he should see error in "user_new" for "First name" if he leaves it empty
    And he should see error in "user_new" for "Last name" if he leaves it empty
    And he should see error in "user_new" for "Email" if he leaves it empty
    And he should see error in "user_new" for "Password" if he leaves it empty
    And he should see error in "user_new" for "Time zone" if he don't choice something
    And he should see error in "user_new" for "Company name" if he leaves it empty
    And he should see error in "user_new" for "Subdomain" if he leaves it empty

  Scenario: Authenticated user successfully edits profile
    Given an activated account
    Given an authenticated user with viewer role
    And he is on the user profile page
    Then he should not see validation errors in "user_edit" form
    And he should see error in "user_edit" for "First name" if he clear it
    And he should see error in "user_edit" for "Last name" if he clear it
    And he should see error in "user_edit" for "Email" if he clear it
    And he should see error in "user_edit" for "Time zone" if he clear select field

  Scenario: Authenticated user successfully account settings
    Given an activated account
    Given an authenticated user with role owner
    When he tries to access to the account edit page
    Then he should not see validation errors in edit_account form
    And he should see error in edit_account for "Company name" if he clear it
    And he should see error in edit_account for "Subdomain" if he clear it
    And he should see error in edit_account for "Time zone" if he clear select field
