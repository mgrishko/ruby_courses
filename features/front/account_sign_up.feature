Feature: Account sign up
  In order to publish company catalog or subscribe to changes
  A company representative
  Should be able to sign up company account

  Scenario: Not registered user signs up a new company account
    Given company representative is on the new account sign up page
    When he fills out the following personal information:
      | First name |
      | Last name  |
      | Email      |
      | Password   |
      | Time zone  |
    And he fills out the following account information:
      | Company   |
      | Country   |
      | Subdomain |
    And he submits the form
    # Delayed account activation steps:
    Then he should be redirected to the signup acknowledgement page
    And he should see notice message "Thank you. We'll send you an invitation once we are ready."
    When an authenticated admin goes to the accounts page
    And he activates account
    Then invitation email should be sent
    When company representative receives an invitation email
    And he clicks company account link
    # Back to our scenario (user is signed in during sign up)
    Then he should be on the company account home page

