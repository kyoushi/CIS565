*** Settings ***
# Import necessary libraries for browser automation, dialog handling, and making HTTP requests
Library    RequestsLibrary
Library    ./lib/CustomLib.py
Library    Collections

*** Variables ***
# Define base URL, API endpoint, and test user information
${api}     http://localhost:3001  # Base URL of the API

*** Test Cases ***
gets a list of contacts by username
    POST    ${api}/testData/seed
    Create Session    alias    ${api}/login
    POST On Session    alias    ${api}/login    params=username=Tavares_Barrows&password=s3cret 
    ${resp}=    GET On Session    alias    ${api}/contacts/Tavares_Barrows
    ${status_code}    Convert To String       ${resp.status_code}
    Should Be Equal    ${status_code}    200
    ${data_results}    Set Variable    ${resp.json()}[contacts]
    Should Contain    ${data_results}[0]    userId 

gets a list of contacts by username
    POST    ${api}/testData/seed
    Create Session    alias    ${api}/login
    POST On Session    alias    ${api}/login    params=username=Tavares_Barrows&password=s3cret 
    ${body}=    Evaluate    json.loads($json_string)    json
    ${resp}=   POST On Session    alias    ${api}/contacts    json=${body}
    ${status_code}    Convert To String       ${resp.status_code}
    Should Be Equal    ${status_code}    200
    ${data_results}    Set Variable    ${resp.json()}
    ${is_String}=    Is String    ${data_results}[contact][id]
    Should Be True    ${is_String}
    Should Be Equal   ${data_results}[contact][contactUserId]    ${body}[contactUserId]

error when invalid contactUserId
    POST    ${api}/testData/seed
    Create Session    alias    ${api}/login
    POST On Session    alias    ${api}/login    params=username=Tavares_Barrows&password=s3cret 
    ${body}=    Evaluate    json.loads($json_string2)    json
    ${resp}=   POST On Session    alias    ${api}/contacts    json=${body}    expected_status=422
    ${data_results}    Set Variable    ${resp.json()}[errors]
    ${data_length}=    get length       ${data_results}
    Should Be True    ${data_length} == 1

*** Variables ***
${json_string}    {"contactUserId": "24VniajY1y"}
${json_string2}    {"contactUserId": "abc"}