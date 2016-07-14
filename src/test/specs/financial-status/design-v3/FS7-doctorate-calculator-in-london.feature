Feature: Total Funds Required Calculation - Tier 4 (General) Student Doctorate In London (single current account and no dependants)

    Acceptance criteria

    Requirement to meet Tier 4 Doctorate passed and not passed

    Inner London - The applicant must show evidence of funds to cover £1,265 for each month remaining of the course up to a maximum of 2 months

    Required Maintenance threshold calculation to pass this feature file
    Maintenance threshold amount =  (Required Maintenance funds doctorate inner London
    borough (£1265) * remaining course length) -  Accommodation fees already paid

    Background:
        Given caseworker is using the financial status service ui
        And the doctorate student type is chosen


    Scenario: Raj is a Doctorate inner London student and does not have sufficient funds
        Given the account does not have sufficient funds
        When the financial status check is performed with
            | End date                        | 30/05/2016 |
            | Inner London borough            | Yes        |
            | Course length                   | 2          |
            | Accommodation fees already paid | 0          |
            | Sort code                       | 11-11-12   |
            | Account number                  | 11111112   |
        Then the service displays the following result
            | Outcome                         | Not passed               |
            | Total funds required            | £16,090.00               |
            | Maintenance period checked      | 03/05/2016 to 30/05/2016 |
            | Inner London borough            | Yes                      |
            | Course length                   | 2                        |
            | Accommodation fees already paid | £0.00                    |
            | Sort code                       | 11-11-12                 |
            | Account number                  | 11111112                 |


    Scenario: Shelly is a Doctorate inner London student and has sufficient funds
        Given the account has sufficient funds
        When the financial status check is performed with
            | End date                        | 30/05/2016 |
            | Inner London borough            | Yes        |
            | Course length                   | 1          |
            | Accommodation fees already paid | 100        |
            | Sort code                       | 22-22-23   |
            | Account number                  | 22222223   |
        Then the service displays the following result
            | Outcome                         | Passed                   |
            | Total funds required            | £16,090.00               |
            | Maintenance period checked      | 03/05/2016 to 30/05/2016 |
            | Inner London borough            | Yes                      |
            | Course length                   | 1                        |
            | Accommodation fees already paid | £100.00                  |
            | Sort code                       | 11-11-12                 |
            | Account number                  | 11111112                 |
