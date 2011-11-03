#Feature: Account activation
#  In order allow access to company account
#  An admin
#  Should be able to activate company account
#
#  Scenario: Admin activates account
#    Given not activated company account
#    When an authenticated admin goes to the accounts page
#    And he activates the account
#    Then an invitation email should be sent
#    When a company representative receives the invitation email
#    And he clicks company account link
#    # Back to our scenario (user is signed in during sign up)
#    Then he should be on the company account home page
#
