@disable-bundler
Feature: Packing the meaty project

  Scenario: --meaty=true
    When I bake a project called "test_project" with:
      | argument | value |
      | --meaty  | true  |
    And I cd to the "test_project" root
    Then unicorn should be installed
