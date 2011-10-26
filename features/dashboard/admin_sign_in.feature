@dashboard
Feature: Admin sign in
  In order to get access to dashboard
  An admin
  Should be able to sign in

  Scenario: Admin signs in successfully
    Given an unauthenticated admin
    When the admin tries to access a restricted page
    Then he should be redirected to the login page
    When admin submits valid credentials
    Then he should be redirected back to the restricted page
