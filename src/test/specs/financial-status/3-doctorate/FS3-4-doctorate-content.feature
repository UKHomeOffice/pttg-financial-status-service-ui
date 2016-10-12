Feature: Tier 4 (General) doctorate extension scheme content (single current account with dependants)

    Background:
        Given caseworker is using the financial status service ui
        And the doctorate student type is chosen


 ###################################### Section - Check for text on Output does not meet minimum financial requirement - Not Passed ######################################

    Scenario: Page checks for Not Passed text write up
    This is a scenario to check if Applicant does not meet minimum financial requirement text write up
        Given the account does not have sufficient funds
        When the financial status check is performed
        Then the service displays the following page content
            | Page dynamic heading | Not passed                                                            |
            | Page dynamic detail  | One or more daily closing balances are below the total funds required |
        And the service displays the following results headers in order
            | Account holder name   |
            | Total funds required  |
            | 28-day period checked |
            | Lowest balance        |
        And the service displays the following your search headers in order
            | Student type                    |
            | In London                       |
            | Accommodation fees already paid |
            | Number of dependants            |
            | Sort code                       |
            | Account number                  |
            | Date of birth                   |


