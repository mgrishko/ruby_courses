Feature: Account sign up
  In order to publish company catalog or subscribe to changes
  A company representative
  Should be able to sign up company account

  Scenario: Not registered user signs up a new company account
    Given company representative is on the new account sign up page
    When he fills out the sign up form with following personal data:
      | First name |
      | Last name  |
      | Email      |
      | Password   |
      | Time zone  |
    And he fills out the sign up form with following account data:
      | Company   |
      | Country   |
      | Subdomain |
    And he submits the sign up form
    # Delayed account activation steps:
    Then he should be redirected to the signup acknowledgement page
    And he should see notice message "Thank you! We will send you an invitation once we are ready."

