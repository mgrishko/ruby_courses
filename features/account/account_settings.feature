Feature: Account edit
  In order to edit account settings
  An account owner
  Should be able to edit company account

  Background: Activated account exists
    Given an activated account

  Scenario Outline: User access to the account settings is denied
    Given an authenticated user with <role> role
    When he goes to the home page
    Then he should not see account settings link in menu
    When he tries access to the account edit page
    Then he should see alert message "Access denied."
    Examples:
      | role   |
      | admin  |
      | editor |

  Scenario: Account owner successfully edits account setings
    Given an authenticated user with owner role
    When he goes to the home page
    Then he should see account settings link in menu
    When he follow Account seetings
    Then he should be redirected to the account settings page
    When he change and submits Company name, Country, Subdomain, Timezone
    Then he should see notice message "Account was successfully updated."
