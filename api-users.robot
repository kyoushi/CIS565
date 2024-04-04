*** Settings ***
# Import necessary libraries for browser automation, dialog handling, and making HTTP requests
Library    RequestsLibrary
Library    ./lib/CustomLib.py

*** Variables ***
# Define base URL, API endpoint, and test user information
${api}     http://localhost:3001  # Base URL of the API

*** Test Cases ***
GET /users gets a list of users
    POST    ${api}/testData/seed
    ${resp}=    GET    ${api}/testData/users    expected_status=200
    ${data_results}    Set Variable    ${resp.json()}[results]
    ${data_length}=    get length       ${data_results}
    Should Be True    ${data_length} > 1

GET /users/:userId get a user
    POST    ${api}/testData/seed
    Create Session    alias    ${api}/login
    ${resp}=    Post Request    alias    ${api}/login    params=username=Tavares_Barrows&password=s3cret 
    ${user_id}    Set Variable     ${resp.json()}[user][id]
    ${resp_user}=    Get Request    alias    ${api}/users/${user_id}
    Log To Console    ${resp_user}
    Log To Console    ${resp_user.json()}[user]
    Should Contain    ${resp_user.json()}[user]    firstName   

GET /users/:userId error when invalid userId
    POST    ${api}/testData/seed
    Create Session    alias    ${api}/login
    ${resp}=    Post Request    alias    ${api}/login    params=username=Tavares_Barrows&password=s3cret 
    ${user_id}    Set Variable     ${resp.json()}[user][id]
    ${resp_user}=    Get Request    alias    ${api}/users/123
    ${status_code}    Convert To String       ${resp_user.status_code}
    Should Be Equal    ${status_code}    422