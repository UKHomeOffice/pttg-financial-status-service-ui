Feature: Total Funds Required Calculation - Tier 4 (General) Student Doctorate In London (single current account including dependants)

    Acceptance criteria

    Requirement to meet Tier 4 Doctorate passed and not passed

    In London - The applicant must show evidence of funds to cover £1,265 per month for 2 months (£2,530)

    Dependants Required Maintenance threshold: In London - £845

    Required Maintenance threshold calculation to pass this feature file
    Maintenance threshold amount =  (Required Maintenance funds doctorate in London
    (£1265) * 2) -  Accommodation fees already paid

    Background:
        Given the api health check response has status 200
        And the api daily balance response will Pass
        And the api consent response will be SUCCESS
        And the api threshold response will be t4
        And caseworker is using the financial status service ui
        And caseworker is on page t4/des/consent
        And the api condition codes response will be 2--
        And consent is sought for the following:
            | DOB            | 25/03/1987 |
            | Sort code      | 33-33-33   |
            | Account number | 33333333   |
        And the default details are
            | Application raised date         | 29/06/2016 |
            | End date                        | 30/05/2016 |
            | In London                       | Yes        |
            | Accommodation fees already paid | 100        |
            | Dependants                      | 0          |


#Added to Jira PT-27 - Add 'Account holder name' to FSPS UI
    Scenario: Shelly is a Doctorate in London student and has sufficient funds
        When the financial status check is performed
        Then the service displays the following result
            | Outcome                         | Passed                         |
            | Account holder name             | Laura Taylor                   |
            | Total funds required            | £16,090.00                     |
            | Maintenance period checked      | 03/05/2016 to 30/05/2016       |
            | Condition Code                  | 2 - Applicant                  |
            | Applicant type                  | Doctorate extension scheme     |
            | Tier                            | Tier 4 (General)               |
            | In London                       | Yes                            |
            | Accommodation fees already paid | £100.00 (limited to £1,265.00) |
            | Dependants                      | 0                              |
            | Sort code                       | 33-33-33                       |
            | Account number                  | 33333333                       |
            | DOB                             | 25/03/1987                     |
            | Application raised date         | 29/06/2016                     |

    Scenario: User clicks on the Begin a new search button after completing financial status check
        When the financial status check is performed
        And the new search button is clicked
        Then the service displays the following page content
            | Page title | Check financial status |



