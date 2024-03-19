*** Settings ***
# Import necessary libraries for browser automation, dialog handling, and making HTTP requests
Library    Browser
Library    Dialogs
Library    RequestsLibrary

*** Variables ***
# Define base URL, API endpoint, and test user information
${host}     http://localhost:3000  # Base URL of the application
${api}     http://localhost:3001  # Base URL of the API
# Dictionary containing test user information
&{userInfo}  username=Katharina_Bernier    password=s3cret
${user1}    Initial Value
${user2}    Initial Value
${user3}    Initial Value


*** Settings ***
# Perform a POST request to seed the database with test data before each test case
Test Setup    Run Multiple Test Setup Steps


*** Test Cases ***
User A likes a transaction of User B; User B gets notification that User A liked transaction
    Open Browser    ${host}/signin
    Find Transaction by senderId     ${user2}[id]   
    # Log To Console  A
    # Log To Console  ${user1}[username]
    Log To Console  ${user2}[id]
    # Log To Console  ${user3}[username]
    # Log To Console  B
    # # Login with the newly created user
    # Fill Text    css=#username   ${userInfo}[username]
    # Fill Text    css=#password   ${userInfo}[password]
    #  ${promise} =  Promise To   Wait For Response  matcher=${api}/notifications    timeout=10s
    # Click    css=[data-test="signin-submit"]
    # Wait For  ${promise}
    # # Log To Console    ${promise.result().status}
    # # Log To Console    ${promise.result().request.postData}
    # Log To Console    ${promise.result().body}
    Pause Execution    Press OK button.

*** Keywords ***
Run Multiple Test Setup Steps
    POST    ${api}/testData/seed
    ${resp}=    GET    ${api}/testData/users
    ${data_results}    Set Variable    ${resp.json()}[results]
    ${data_length}=    get length       ${data_results}
    Set Test Variable    ${user1}    ${data_results}[0]
    Set Test Variable    ${user2}    ${data_results}[1]
    Set Test Variable    ${user3}    ${data_results}[2]

Find Transaction by senderId
    [Arguments]    ${sender_id}
    ${json_data}    {"items": [
                    {"id": 1, "name": "Alice", "age": 30},
                    {"id": 2, "name": "Bob", "age": 25},
                    {"id": 3, "name": "Charlie", "age": 35}
                ]}

    # ${resp}=    GET    ${api}/testData/transactions
    # ${data_results}    Set Variable    ${resp.json()}[results][0]
    # {json_object}=    Parse Json    ${data_results}
    # FOR ${senderId} IN @{data_results}
    # Log ${senderId}
    # # Perform other actions on ${item}
    # END
    # # Log To Console    ${data_results}[0][]