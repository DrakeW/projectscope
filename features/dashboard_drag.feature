@javascript @vcr @omniauth
Feature: Sort projects by metrics

  As a coach or admin on the dashboard page
  So that I can drag projects in table

  Background:
    Given I am logged in
    And the following projects exist:
      | name          |
      | project scope |
      | city dog      |
      | esential      |
      | faludi design |
      | oram          |

  Scenario: drag down
    When I am on the projects page
    And I drag city dog 1 row down
    Then I should see esential above city dog

#   Scenario: drag downwards
#     Given I am on the dashboard page
#     And I drag project scope after faludi design
#     Then I should see project scope after faludi design
