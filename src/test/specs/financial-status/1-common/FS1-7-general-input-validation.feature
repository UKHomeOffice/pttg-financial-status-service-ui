Feature: Show clear error details when inputs are invalid

    Fields mandatory to fill in:
    Application Raised Date - should be dd/mm/yyyy (always 8 numbers, 0-9, no letters, cannot be all 0's)
    End Date - Format should be dd/mm/yyyy and the End date has to be less than 32 days before the application raised date
    Date of birth - should be dd/mm/yyyy (always 8 numbers, 0-9, no letters, cannot be all 0's)
    Dependants - should always be 0 for courses of six months or less ####
    Sort code - Format should be three pairs of digits 13-56-09 (always numbers 0-9, no letters and cannot be all 0's)
    Account Number - Format should be 12345678 (always 8 numbers, 0-9, no letters, cannot be all 0's)
    Start Date of course
    End Date of course
    In London - Yes or No options (mandatory)
    Application Raised Date - numbers only
    Continuation Course - 'Yes, continuation' or 'No' options (mandatory)
    Original Course Start Date - numbers only (if Continuation Course is selected as Yes)

    Background:
        Given caseworker is using the financial status service ui
        And caseworker is on page t4/status/main/general

######################### General validation message display #########################

    Scenario: Error summary details are shown when a validation error occurs
        When the financial status check is performed with
            | Application raised date         |  |
            | End Date                        |  |
            | In London                       |  |
            | Course start date               |  |
            | Course end date                 |  |
            | Total tuition fees              |  |
            | Tuition fees already paid       |  |
            | Accommodation fees already paid |  |
            | Dependants                      |  |
            | Continuation Course             |  |
            | Course type                     |  |
            | Course institution              |  |
            | Sort code                       |  |
            | Account number                  |  |
            | DOB                             |  |
        Then the service displays the following message
            | validation-error-summary-heading | There's some invalid information                  |
            | validation-error-summary-text    | Make sure that all the fields have been completed |
        And the error summary list contains the text
            | The application raised date is invalid         |
            | The end date is invalid                        |
            | The in London option is invalid                |
            | The start date of course is invalid            |
            | The end date of course is invalid              |
            | The total tuition fees is invalid              |
            | The tuition fees already paid is invalid       |
            | The accommodation fees already paid is invalid |
            | The number of dependants is invalid            |
            | The course continuation option is invalid      |
            | The course type option is invalid              |
            | The course institution option is invalid       |


######################### Validation on the Application Raised Date Field #########################
    Scenario: Case Worker does NOT enter Application Raised Date
        When the financial status check is performed with
            | Application raised Date |  |
        Then the service displays the following error message
            | Application raised Date-error | Enter a valid application raised date |

    Scenario: Case Worker enters invalid Application Raised Date: in the future
        When the financial status check is performed with
            | Application raised Date | 30/05/2099 |
        Then the service displays the following error message
            | Application raised Date-error | Enter a valid application raised date |

    Scenario: Case Worker enters invalid Application Raised Date: not numbers
        When the financial status check is performed with
            | Application raised Date | 30/d5/2015 |
        Then the service displays the following error message
            | Application raised Date-error | Enter a valid application raised date |



######################### Validation on the End Date Field #########################
    Scenario: Case Worker does NOT enter End Date
        When the financial status check is performed with
            | End Date |  |
        Then the service displays the following error message
            | End Date-error | Enter a valid end date |

    Scenario: Case Worker enters invalid End Date - in the future
        When the financial status check is performed with
            | End Date | 30/05/2099 |
        Then the service displays the following error message
            | End Date-error | Enter a valid end date |

    Scenario: Case Worker enters invalid End date - not numbers 0-9
        When the financial status check is performed with
            | End Date | 30/0d/2016 |
        Then the service displays the following error message
            | End Date-error | Enter a valid end date |

    Scenario: Case Worker enters invalid End date - after application raised date
        When the financial status check is performed with
            | End Date | 31/06/2016 |
        Then the service displays the following error message
            | End Date-error | Enter a valid end date |

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
            | Course Start Date-error | Enter a valid start date of course |

    Scenario: Case Worker does NOT enter Course end date
        When the financial status check is performed with
            | Course end date |  |
        Then the service displays the following error message
            | Course End Date-error | Enter a valid end date of course |

    Scenario: Case Worker enters invalid Course start date - not numbers 0-9
        When the financial status check is performed with
            | Course start date | 30/0d/2016 |
        Then the service displays the following error message
            | Course Start Date-error | Enter a valid start date of course |

    Scenario: Case Worker enters invalid Course Length - same day
        When the financial status check is performed with
            | Course start date | 30/05/2016 |
            | Course end date   | 30/05/2016 |
        Then the service displays the following error message
            | Course End Date-error | Enter a valid course length |

    Scenario: Case Worker enters invalid Course Length - end before start
        When the financial status check is performed with
            | Course start date | 30/05/2016 |
            | Course end date   | 30/04/2016 |
        Then the service displays the following error message
            | Course End Date-error | Enter a valid course length |

######################### Validation on the Total tuition fees Field #########################
    Scenario: Case Worker does NOT enter Total tuition fees
        When the financial status check is performed with
            | Total tuition fees |  |
        Then the service displays the following error message
            | total tuition fees-error | Enter a valid total tuition fees |

    Scenario: Case Worker enters invalid Total tuition fees - not numbers 0-9
        When the financial status check is performed with
            | Total tuition fees | A |
        Then the service displays the following error message
            | total tuition fees-error | Enter a valid total tuition fees |

######################### Validation on the Tuition fees already paid Field #########################
    Scenario: Case Worker does NOT enter Tuition fees already paid
        When the financial status check is performed with
            | Tuition fees already paid |  |
        Then the service displays the following error message
            | tuition fees already paid-error | Enter a valid tuition fees already paid |

    Scenario: Case Worker enters invalid Tuition fees already paid - not numbers 0-9
        When the financial status check is performed with
            | Tuition fees already paid | A |
        Then the service displays the following error message
            | tuition fees already paid-error | Enter a valid tuition fees already paid |

######################### Validation on the Accommodation fees already paid Field #########################
    Scenario: Case Worker does NOT enter Accommodation fees already paid
        When the financial status check is performed with
            | Accommodation fees already paid |  |
        Then the service displays the following error message
            | Accommodation Fees Already Paid-error | Enter a valid accommodation fees already paid |

    Scenario: Case Worker enters invalid Accommodation fees already paid - not numbers 0-9
        When the financial status check is performed with
            | Accommodation fees already paid | A |
        Then the service displays the following error message
            | Accommodation Fees Already Paid-error | Enter a valid accommodation fees already paid |

######################### Validation on the Dependants Field #########################
    Scenario: Case Worker does NOT enter Dependants
        When the financial status check is performed with
            | Dependants |  |
        Then the service displays the following error message
            | Dependants-error | Enter a valid number of dependants |

    Scenario: Case Worker enters invalid Dependants - not numbers 0-9
        When the financial status check is performed with
            | Dependants | A |
        Then the service displays the following error message
            | Dependants-error | Enter a valid number of dependants |

    Scenario: Case Worker enters invalid Dependants - negative
        When the financial status check is performed with
            | Dependants | -1 |
        Then the service displays the following error message
            | Dependants-error | Enter a valid number of dependants |

    Scenario: Case Worker enters invalid Dependants - fractional
        When the financial status check is performed with
            | Dependants | 1.1 |
        Then the service displays the following error message
            | Dependants-error | Enter a valid number of dependants |

    Scenario: Case Worker enters invalid Dependants - CANNOT be zero on a dependants only route
        Given caseworker is on page t4/general-dependants/calc/details
        When the financial status check is performed with
            | Dependants | 0 |
        Then the service displays the following error message
            | Dependants-error | Enter a valid number of dependants |


        ######################### Validation on the Application Raised Date Field #########################

    Scenario: Case Worker does NOT enter Application Raised date
        When the financial status check is performed with
            | Application Raised Date |  |
        Then the service displays the following error message
            | Application Raised Date-error | Enter a valid application raised date |

    Scenario: Case Worker enters invalid Course start date - not numbers 0-9
        When the financial status check is performed with
            | Application Raised Date | 30/1d/2016 |
        Then the service displays the following error message
            | Application Raised Date-error | Enter a valid application raised date |

    Scenario: Case Worker enters Original Course Start Date - in the future
        When the financial status check is performed with
            | Application Raised Date | 30/05/2099 |
        Then the service displays the following error message
            | Application Raised Date-error | Enter a valid application raised date |

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
            | Original Course Start Date-error | Enter a valid original course start date |

    Scenario: Case Worker enters invalid Original Course Start Date - not numbers 0-9
        When the financial status check is performed with
            | Original Course Start Date | 30/1d/2016 |
            | Continuation Course        | Yes        |
        Then the service displays the following error message
            | Original Course Start Date-error | Enter a valid original course start date |

    Scenario: Case Worker enters Original Course Start Date - in the future
        When the financial status check is performed with
            | Continuation Course        | Yes        |
            | Original Course Start Date | 30/05/2099 |
        Then the service displays the following error message
            | Original Course Start Date-error | Enter a valid original course start date |

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
            | sort Code-error | Enter a valid sort code |

    Scenario: Case Worker enters invalid Sort Code - mising digits
        When the financial status check is performed with
            | Sort code | 11-11-1 |
        Then the service displays the following error message
            | sort Code-error | Enter a valid sort code |

    Scenario: Case Worker enters invalid Sort Code - all 0's
        When the financial status check is performed with
            | Sort code | 00-00-00 |
        Then the service displays the following error message
            | sort Code-error | Enter a valid sort code |

    Scenario: Case Worker enters invalid Sort Code - not numbers 0-9
        When the financial status check is performed with
            | Sort code | 11-11-1q |
        Then the service displays the following error message
            | sort Code-error | Enter a valid sort code |


######################### Validation on the Account Number Field #########################

    Scenario: Case Worker does NOT enter Account Number
        When the financial status check is performed with
            | Account number |  |
        Then the service displays the following error message
            | account number-error | Enter a valid account number |

    Scenario: Case Worker enters invalid Account Number - too short
        When the financial status check is performed with
            | Account number | 1111111 |
        Then the service displays the following error message
            | account number-error | Enter a valid account number |


    Scenario: Case Worker enters invalid Account Number - all 0's
        When the financial status check is performed with
            | Account number | 00000000 |
        Then the service displays the following error message
            | account number-error | Enter a valid account number |

    Scenario: Case Worker enters invalid Account Number - not numbers 0-9
        When the financial status check is performed with
            | Account number | 111a1111 |
        Then the service displays the following error message
            | account number-error | Enter a valid account number |

######################### Validation on the Date of birth Field #########################

    Scenario: Case Worker does NOT enter Date of birth
        When the financial status check is performed with
            | DOB |  |
        Then the service displays the following error message
            | dob-error | Enter a valid date of birth |

    Scenario: Case Worker enters invalid Date of birth - in the future
        When the financial status check is performed with
            | DOB | 25/09/2099 |
        Then the service displays the following error message
            | dob-error | Enter a valid date of birth |

    Scenario: Case Worker enters invalid Date of birth - not numbers 0-9
        When the financial status check is performed with
            | DOB | 25/08/198x |
        Then the service displays the following error message
            | dob-error | Enter a valid date of birth |