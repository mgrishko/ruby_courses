Feature: Account membership management
  In order to protect account data from non-members
  A user
  Should be prompted to login if he isn't a member of an account

  Scenario: Non-member of an account is prompted to login
    Given account with memberships
    And an authenticated user with admin role
    And another active account
    When user navigates to another account home page
    Then he should be prompted to login to another account
  
  Scenario: Anonimous is prompted to login
    Given another active account
    When user navigates to another account home page
    Then he should be prompted to login to another account

  Scenario: User is signed out when logs in as another user
    Given account with memberships
    And an authenticated user with admin role
    And another active account
    When user navigates to another account home page
    Then he should be prompted to login to another account
    When he logs in as another account user
    And he navigates to account home page
    Then he should be prompted to login to account
