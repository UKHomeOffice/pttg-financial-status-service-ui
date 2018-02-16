Feature: Show clear error details when inputs are invalid

#    Fields mandatory to fill in:
#    Application Raised Date - should be dd/mm/yyyy (always 8 numbers, 0-9, no letters, cannot be all 0's)
#    End Date - Format should be dd/mm/yyyy and the End date has to be less than 32 days before the application raised date
#    Date of birth - should be dd/mm/yyyy (always 8 numbers, 0-9, no letters, cannot be all 0's)
#    Dependants - should always be 0 for courses of six months or less ####
#    Sort code - Format should be three pairs of digits 13-56-09 (always numbers 0-9, no letters and cannot be all 0's)
#    Account Number - Format should be 12345678 (always 8 numbers, 0-9, no letters, cannot be all 0's)
#    Start Date of course
#    End Date of course
#    In London - Yes or No options (mandatory)
#    Application Raised Date - numbers only
#    Continuation Course - 'Yes, continuation' or 'No' options (mandatory)
#    Original Course Start Date - numbers only (if Continuation Course is selected as Yes)

    Background:
        Given caseworker is using the financial status service ui
        And caseworker is on page t4/application/status/main/general

######################### General validation message display #########################

    Scenario: Error summary details are shown when a validation error occurs
        When the financial status check is performed with
            | Application raised date |  |
            | End Date                |  |
            | In London               |  |
            | Course start date       |  |
            | Course end date         |  |
            | Tuition fees            |  |
            | Tuition fees paid       |  |
            | Accommodation fees paid |  |
            | Dependants              |  |
            | Continuation Course     |  |
            | Course type             |  |
            | Course institution      |  |
            | Sort code               |  |
            | Account number          |  |
            | DOB                     |  |
        Then the service displays the following page content
            | validation-error-summary-heading | There's some invalid information                  |
            | validation-error-summary-text    | Make sure that all the fields have been completed |
        And the error summary list contains the text
            | The "Date of birth" is invalid         |
            | The "Sort code" is invalid         |
            | The "Account number" is invalid         |
            | The "Application raised date" is invalid         |
            | The "End date" is invalid                        |
            | The "Number of dependants" is invalid            |
            | The "In London" option is invalid                |
            | The "Course type" option is invalid              |
            | The "Course institution" option is invalid       |
            | The "Start date of course" is invalid            |
            | The "End date of course" is invalid              |
            | The "Course continuation" option is invalid      |
            | The "Total tuition fees" is invalid              |
            | The "Tuition fees already paid" is invalid       |
            | The "Accommodation fees already paid" is invalid |
            

######################### Validation on the Application Raised Date Field #########################
    Scenario: Case Worker does NOT enter Application Raised Date
        When the financial status check is performed with
            | Application raised Date |  |
        Then the service displays the following error message
            | Application raised Date-error | Enter a valid "Application raised date" |

    Scenario: Case Worker enters invalid Application Raised Date: in the future
        When the financial status check is performed with
            | Application raised Date | 30/05/2099 |
        Then the service displays the following error message
            | Application raised Date-error | Enter a valid "Application raised date" |

    Scenario: Case Worker enters invalid Application Raised Date: not numbers
        When the financial status check is performed with
            | Application raised Date | 30/d5/2015 |
        Then the service displays the following error message
            | Application raised Date-error | Enter a valid "Application raised date" |



######################### Validation on the End Date Field #########################
    Scenario: Case Worker does NOT enter End Date
        When the financial status check is performed with
            | End Date |  |
        Then the service displays the following error message
            | End Date-error | Enter a valid "End date" |

    Scenario: Case Worker enters invalid End Date - in the future
        When the financial status check is performed with
            | End Date | 30/05/2099 |
        Then the service displays the following error message
            | End Date-error | Enter a valid "End date" |

    Scenario: Case Worker enters invalid End date - not numbers 0-9
        When the financial status check is performed with
            | End Date | 30/0d/2016 |
        Then the service displays the following error message
            | End Date-error | Enter a valid "End date" |

    Scenario: Case Worker enters invalid End date - after application raised date
        When the financial status check is performed with
            | End Date | 31/06/2016 |
        Then the service displays the following error message
            | End Date-error | Enter a valid "End date" |

    Scenario: Case Worker enters invalid End date - within 31 days of application raised date
        When the financial status check is performed with
            | End Date                | 30/05/2016 |
            | Application raised date | 31/01/2016 |
        Then the service displays the following error message
            | End Date-error | End date cannot be after application raised date |

    Scenario: Caseworker enters end date after the Application Raised Date
        When the financial status check is performed with
            | End Date                | 01/02/2016 |
            | Application raised date | 31/01/2016 |
        Then the service displays the following error message
            | End Date-error | End date cannot be after application raised date |

    Scenario: Caseworker enters end date more than 30 days before the Application Raised Date (31 days including App Raised Date)
        When the financial status check is performed with
            | End Date                | 31/12/2015 |
            | Application raised date | 31/01/2016 |
        Then the service displays the following error message
            | End Date-error | End date is not within 31 days of application raised date |

######################### Validation on the In London Field #########################
    Scenario: Case Worker does NOT enter In London
        When the financial status check is performed with
            | In London |  |
        Then the service displays the following error message
            | In London-error | Select an option |


######################### Validation on the Course start / end fields #########################
    Scenario: Case Worker does NOT enter Course start date
        When the financial status check is performed with
            | Course start date |  |
        Then the service displays the following error message
            | Course Start Date-error | Enter a valid "Start date of course" |

    Scenario: Case Worker does NOT enter Course end date
        When the financial status check is performed with
            | Course end date |  |
        Then the service displays the following error message
            | Course End Date-error | Enter a valid "End date of course" |

    Scenario: Case Worker enters invalid Course start date - not numbers 0-9
        When the financial status check is performed with
            | Course start date | 30/0d/2016 |
        Then the service displays the following error message
            | Course Start Date-error | Enter a valid "Start date of course" |

    Scenario: Case Worker enters invalid Course Length - same day
        When the financial status check is performed with
            | Course start date | 30/05/2016 |
            | Course end date   | 30/05/2016 |
        Then the service displays the following error message
            | Course End Date-error | Enter a valid "Course length" |

    Scenario: Case Worker enters invalid Course Length - end before start
        When the financial status check is performed with
            | Course start date | 30/05/2016 |
            | Course end date   | 30/04/2016 |
        Then the service displays the following error message
            | Course End Date-error | Enter a valid "Course length" |

######################### Validation on the Tuition fees Field #########################
    Scenario: Case Worker does NOT enter Tuition fees
        When the financial status check is performed with
            | Tuition fees |  |
        Then the service displays the following error message
            | Tuition fees-error | Enter a valid "Total tuition fees" |

    Scenario: Case Worker enters invalid Tuition fees - not numbers 0-9
        When the financial status check is performed with
            | Tuition fees | A |
        Then the service displays the following error message
            | Tuition fees-error | Enter a valid "Total tuition fees" |

######################### Validation on the Tuition fees paid Field #########################
    Scenario: Case Worker does NOT enter Tuition fees paid
        When the financial status check is performed with
            | Tuition fees paid |  |
        Then the service displays the following error message
            | Tuition fees paid-error | Enter a valid "Tuition fees already paid" |

    Scenario: Case Worker enters invalid Tuition fees paid - not numbers 0-9
        When the financial status check is performed with
            | Tuition fees paid | A |
        Then the service displays the following error message
            | Tuition fees paid-error | Enter a valid "Tuition fees already paid" |

######################### Validation on the Accommodation fees paid Field #########################
    Scenario: Case Worker does NOT enter Accommodation fees paid
        When the financial status check is performed with
            | Accommodation fees paid |  |
        Then the service displays the following error message
            | Accommodation fees paid-error | Enter a valid "Accommodation fees already paid" |

    Scenario: Case Worker enters invalid Accommodation fees paid - not numbers 0-9
        When the financial status check is performed with
            | Accommodation fees paid | A |
        Then the service displays the following error message
            | Accommodation fees paid-error | Enter a valid "Accommodation fees already paid" |

######################### Validation on the Dependants Field #########################
    Scenario: Case Worker does NOT enter Dependants
        When the financial status check is performed with
            | Dependants |  |
        Then the service displays the following error message
            | Dependants-error | Enter a valid "Number of dependants" |

    Scenario: Case Worker enters invalid Dependants - not numbers 0-9
        When the financial status check is performed with
            | Dependants | A |
        Then the service displays the following error message
            | Dependants-error | Enter a valid "Number of dependants" |

    Scenario: Case Worker enters invalid Dependants - negative
        When the financial status check is performed with
            | Dependants | -1 |
        Then the service displays the following error message
            | Dependants-error | Enter a valid "Number of dependants" |

    Scenario: Case Worker enters invalid Dependants - fractional
        When the financial status check is performed with
            | Dependants | 1.1 |
        Then the service displays the following error message
            | Dependants-error | Enter a valid "Number of dependants" |

    Scenario: Case Worker enters invalid Dependants - CANNOT be zero on a dependants only route
        Given caseworker is on page t4/application/calc/dependant/general
        When the financial status check is performed with
            | Dependants | 0 |
        Then the service displays the following error message
            | Dependants-error | Enter a valid "Number of dependants" |


        ######################### Validation on the Application Raised Date Field #########################

    Scenario: Case Worker does NOT enter Application Raised date
        When the financial status check is performed with
            | Application Raised Date |  |
        Then the service displays the following error message
            | Application Raised Date-error | Enter a valid "Application raised date" |

    Scenario: Case Worker enters invalid Course start date - not numbers 0-9
        When the financial status check is performed with
            | Application Raised Date | 30/1d/2016 |
        Then the service displays the following error message
            | Application Raised Date-error | Enter a valid "Application raised date" |

    Scenario: Case Worker enters Original Course Start Date - in the future
        When the financial status check is performed with
            | Application Raised Date | 30/05/2099 |
        Then the service displays the following error message
            | Application Raised Date-error | Enter a valid "Application raised date" |

    ######################### Validation on the Continuation Course Field #########################

    Scenario: Case Worker does NOT enter Continuation Course
        When the financial status check is performed with
            | Continuation Course |  |
        Then the service displays the following error message
            | Continuation Course-error | Select an option |

    ######################### Validation on the Original Course Start Date Field #########################

    Scenario: Case Worker does NOT enter Original Course Start Date
        When the financial status check is performed with
            | Continuation Course        | Yes |
            | Original Course Start Date |     |
        Then the service displays the following error message
            | Original Course Start Date-error | Enter a valid "Original course start date" |

    Scenario: Case Worker enters invalid Original Course Start Date - not numbers 0-9
        When the financial status check is performed with
            | Original Course Start Date | 30/1d/2016 |
            | Continuation Course        | Yes        |
        Then the service displays the following error message
            | Original Course Start Date-error | Enter a valid "Original course start date" |

    Scenario: Case Worker enters Original Course Start Date - in the future
        When the financial status check is performed with
            | Continuation Course        | Yes        |
            | Original Course Start Date | 30/05/2099 |
        Then the service displays the following error message
            | Original Course Start Date-error | Enter a valid "Original course start date" |

######################### Validation on the Course institution Field #########################

    Scenario: Case Worker does NOT enter Course institution
        When the financial status check is performed with
            | Course institution |  |
        Then the service displays the following error message
            | Course institution-error | Select an option |

        ######################### Validation on the Sort Code Field #########################

    Scenario: Case Worker does NOT enter Sort Code
        When the financial status check is performed with
            | Sort code |  |
        Then the service displays the following error message
            | sort Code-error | Enter a valid "Sort code" |

    Scenario: Case Worker enters invalid Sort Code - mising digits
        When the financial status check is performed with
            | Sort code | 11-11-1 |
        Then the service displays the following error message
            | sort Code-error | Enter a valid "Sort code" |

    Scenario: Case Worker enters invalid Sort Code - all 0's
        When the financial status check is performed with
            | Sort code | 00-00-00 |
        Then the service displays the following error message
            | sort Code-error | Enter a valid "Sort code" |

    Scenario: Case Worker enters invalid Sort Code - not numbers 0-9
        When the financial status check is performed with
            | Sort code | 11-11-1q |
        Then the service displays the following error message
            | sort Code-error | Enter a valid "Sort code" |


######################### Validation on the Account Number Field #########################

    Scenario: Case Worker does NOT enter Account Number
        When the financial status check is performed with
            | Account number |  |
        Then the service displays the following error message
            | account number-error | Enter a valid "Account number" |

    Scenario: Case Worker enters invalid Account Number - too short
        When the financial status check is performed with
            | Account number | 1111111 |
        Then the service displays the following error message
            | account number-error | Enter a valid "Account number" |


    Scenario: Case Worker enters invalid Account Number - all 0's
        When the financial status check is performed with
            | Account number | 00000000 |
        Then the service displays the following error message
            | account number-error | Enter a valid "Account number" |

    Scenario: Case Worker enters invalid Account Number - not numbers 0-9
        When the financial status check is performed with
            | Account number | 111a1111 |
        Then the service displays the following error message
            | account number-error | Enter a valid "Account number" |

######################### Validation on the Date of birth Field #########################

    Scenario: Case Worker does NOT enter Date of birth
        When the financial status check is performed with
            | DOB |  |
        Then the service displays the following error message
            | dob-error | Enter a valid "Date of birth" |

    Scenario: Case Worker enters invalid Date of birth - in the future
        When the financial status check is performed with
            | DOB | 25/09/2099 |
        Then the service displays the following error message
            | dob-error | Enter a valid "Date of birth" |

    Scenario: Case Worker enters invalid Date of birth - not numbers 0-9
        When the financial status check is performed with
            | DOB | 25/08/198x |
        Then the service displays the following error message
            | dob-error | Enter a valid "Date of birth" |
