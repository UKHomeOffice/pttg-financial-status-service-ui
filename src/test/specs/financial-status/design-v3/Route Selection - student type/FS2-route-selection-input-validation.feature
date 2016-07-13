Feature: Show clear error details when inputs are invalid - Tier 4 (General) student non Doctorate and Doctorate In London (single current account and no dependants)

    Acceptance criteria

    Fields mandatory to fill in:
    Student Types:
    Tier 4 (General) student (non-doctorate)
    Tier 4 (General) student (doctorate)

######################### Validation on the Student type Field #########################

    Scenario: Case Worker does NOT select student type
        Given caseworker is using the financial status service ui
        When the financial status check is performed with
            | Student type |  |
        Then the service displays the following message
            | Error Message | Select an option   |
            | Error Field   | student-type-error |
