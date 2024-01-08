Feature: User Account Management
  Scenario: Creating a user and binding to an account
    Given I have a new user
    And I have a new account
    When I bind the user to the account
    Then I should be able to query the user and account details via GraphQL
