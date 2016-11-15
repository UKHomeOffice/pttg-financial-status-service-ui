Feature: Total Funds Required Calculation - Tier 4 (General) Student Doctorate In London (single current account including dependants)

    Acceptance criteria

    Requirement to meet Tier 4 Doctorate passed and not passed

    In London - The applicant must show evidence of funds to cover £1,265 per month for 2 months (£2,530)

    Required Maintenance threshold calculation to pass this feature file
    Maintenance threshold amount =  (Required Maintenance funds doctorate in London
    (£1265) * 2) -  Accommodation fees already paid

    Background:
        Given the api health check response has status 200
        And caseworker is using the financial status service ui
        And the doctorate student type is chosen
        And the default details are
            | End date                        | 30/05/2016 |
            | In London                       | Yes        |
            | Accommodation fees already paid | 100        |
            | Number of dependants            | 0          |
            | Sort code                       | 22-22-23   |
            | Account number                  | 22222223   |
            | DOB                             | 25/03/1987 |

#Added to Jira PT-27 - Add 'Account holder name' to FSPS UI
    Scenario: Shelly is a Doctorate in London student and has sufficient funds
        Given the account has sufficient funds
        When the financial status check is performed
        Then the service displays the following result
            | Outcome                         | Passed                                                |
            | Account holder name             | Laura Taylor                                          |
            | Total funds required            | £16,090.00                                            |
            | Maintenance period checked      | 03/05/2016 to 30/05/2016                              |
            | Student type                    | Tier 4 (General) student (doctorate extension scheme) |
            | In London                       | Yes                                                   |
            | Accommodation fees already paid | £100.00 (limited to £1,265.00)                        |
            | Number of dependants            | 0                                                     |
            | Sort code                       | 22-22-23                                              |
            | Account number                  | 22222223                                              |
            | DOB                             | 25/03/1987                                            |

    Scenario: User clicks on the Begin a new search button after completing financial status check
        Given the account has sufficient funds
        When the financial status check is performed
        And the new search button is clicked
        Then the service displays the following page content
            | Page title     | Online statement checker for a Barclays current account holder (must be in the applicant’s name only). |
