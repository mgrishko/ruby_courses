Feature: Supplier login - logout
  In order to test login process
  As a supplier
  I want to login and logout

  Scenario: Login
    Given "supplier" has gln "1234" and password "1234"
    When I go to the login page
    And I fill in "Gln" with "1234"
    And I fill in "Password" with "1234"
    And I press "Login"
    Then I should see "Log off"

  Scenario: Logout
    Given "supplier" has gln "1234" and password "1234"
    And I logged in as "supplier"
    When I go to the home page
    And I follow "Log off"
    Then I should be on the login page

