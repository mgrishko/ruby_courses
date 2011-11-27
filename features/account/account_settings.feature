@allow-rescue
Feature: Account edit
  In order to edit account settings
  An account owner
  Should be able to edit company account

  Background: Activated account exists
    Given active account

  Scenario Outline: User access to the account settings is denied
    Given an authenticated user with role <role>
    When he goes to the home page
    Then he should not see "Settings" link within header
    When he tries to access to the account edit page
    Then he should see alert message "You are not authorized to access this page."
    Examples:
      | role   |
      | editor |
      | admin  |

  Scenario: Account owner successfully edits account setings
    Given an authenticated user with role owner
    When he goes to the home page
    Then he should see "Settings" link within header
    When he follows "Settings"
    Then he should be redirected to the account settings page
    When he changes and submit Company name, Country, Subdomain, Timezone
    Then he should see notice message "Account was successfully updated."
