@wip
@javascript
Feature: User main forms input must be validate on client side
  In order to filling forms faster
  An non-registered and later authenticated user
  Should be able to see cliend side validation

  Scenario: Non registered user sign up a new company account
    Given company representative is on the new account sign up page
    Then he should not see validation errors in "user_new" form
    And he should see validation error in "user_new" for "First name" if he leaves it empty
    And he should see validation error in "user_new" for "Last name" if he leaves it empty
    #And he should see validation error in "user_new" for "Email" if he leaves it empty
    And he should see validation error in "user_new" for "Password" if he leaves it empty
    #And he should see validation error in "user_new" for "user_time_zone" if he don't choice something
    And he should see validation error in "user_new" for "Company name" if he leaves it empty
    #And he should see validation error in "user_new" for "Country" if he don't choice something
    And he should see validation error in "user_new" for "Subdomain" if he leaves it empty

  #Scenario: Authenticated user successfully edits profile
    #Given active account
    #Given an authenticated user with role owner
    #And he is on the user profile page
    #Then show me the page
    #Then he should not see validation errors in "user_edit" form
    #And he should see validation error in "user_edit" for "First name" if he leaves it empty
    #And he should see validation error in "user_edit" for "Last name" if he leaves it empty
    #And he should see validation error in "user_edit" for "Email" if he leaves it empty
    #And he should see validation error in "user_edit" for "Time zone" if he don't choice zone
    #And he should see validation error in "user_edit" for "Current password" if he leaves it empty

  #Scenario: Authenticated user successfully account settings
    #Given active account
    #Given an authenticated user with role owner
    ##using previous writing step below
    #When he tries to access to the account edit page
    #Then he should not see validation errors in ".edit_account" form
    #And he should see validation error in ".edit_account" for "Company name" if he leaves it empty
    #And he should see validation error in ".edit_account" for "Country" if he don't choice country
    #And he should see validation error in ".edit_account" for "Subdomain" if he leaves it empty
    #And he should see validation error in ".edit_account" for "Time zone" if he don't choice zone
