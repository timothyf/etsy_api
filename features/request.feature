Feature: Request
  In order to portray request
  As a CLI
  I want to be as objective as possible

  Scenario: Broccoli is gross
    When I run `etsy_api portray broccoli`
    Then the output should contain "Gross!"
