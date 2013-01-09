@disable-bundler
Feature: Creating a Heroku app

  Scenario: --heroku=true
    When I bake a project called "test_project" with:
      | argument | value |
      | --heroku | true  |
    Then the "test_project-staging" Heroku app should exist
    And the "test_project" Heroku app should exist
