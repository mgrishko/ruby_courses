Feature: Account sign up
  In order to publish company catalog or subscribe to changes
  A company representative
  Should be able to sign up company account

  Scenario: Not registered user signs up a new company account
    Given company representative is on the sign up page
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
      | Website   |
      | A few words about your company |
    And he submits the sign up form
    # Delayed account activation steps:
    Then he should be redirected to the signup acknowledgement page
    And he should see notice message "Invitation request was sent successfully."
    And he should see text "Thank you! We will send you an invitation once we are ready."

  Scenario: Registered user goes to acknowledgement page manually
    When he goes to the acknowledgement page manually
    Then he should not see text "Thank you! We will send you an invitation once we are ready."

  Scenario: Signup with taken subdomain
    Given company representative is on the sign up page
    When he submits sign up form with taken subdomain
    Then he should be redirected back to the sign up page
    And he should see that subdomain not available

  @javascript
  Scenario: Sign up account form is validated on the client side
    Given company representative is on the sign up page
    Then he should not see validation errors on the page
    And he should see an error for "First name" text field if it is empty
    And he should see an error for "Last name" text field if it is empty
    And he should see an error for "Email" text field if it is empty
    And he should see an error for "Password" text field if it is empty
    And he should see an error for "Time zone" select field if it is empty
    And he should see an error for "Company" text field if it is empty
    And he should see an error for "Subdomain" text field if it is empty
    And he should not see an error for "Website" text field if it is empty
    And he should not see an error for "A few words about your company" text field if it is empty

  Scenario: Signed in user creates a new company account with existing email
    Given an authenticated user
    When he goes to the sign up page
    Then he should be redirected to the new account page
    And he should see signed in as email and user name within user info
    When he fills out the sign up form with following account data:
      | Company   |
      | Country   |
      | Subdomain |
      | Website   |
      | A few words about your company |
    And he submits the sign up form
    # Delayed account activation steps:
    Then he should be redirected to the signup acknowledgement page
    And he should see notice message "Invitation request was sent successfully."
    And he should see text "Thank you! We will send you an invitation once we are ready."

  Scenario: Unsigned user can sign in from sign up form
    Given an unauthenticated user
    When he goes to the sign up page
    And he follows "Sign in here" within login box
    Then he should be on the global sign in page
    When user submits valid email and password
    Then he should be redirected to the new account page

  Scenario: Signed in user can sign out from create new account form
    Given an authenticated user
    And he is on the new account page
    When he follows "Sign out" within user info
    Then he should be redirected to the sign up page
