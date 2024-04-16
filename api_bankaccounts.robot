*** Settings ***
# Import necessary libraries for browser automation, dialog handling, and making HTTP requests
Library    RequestsLibrary
Library    ./lib/CustomLib.py
Library    Collections

*** Variables ***
# Define base URL, API endpoint, and test user information
${api}     http://localhost:3001  # Base URL of the API

*** Test Cases ***
gets a list of bank accounts for user
    POST    ${api}/testData/seed
    Create Session    alias    ${api}/login
    POST On Session    alias    ${api}/login    params=username=Tavares_Barrows&password=s3cret 
    ${resp}=    GET On Session    alias    ${api}/bankAccounts
    ${status_code}    Convert To String       ${resp.status_code}
    Should Be Equal    ${status_code}    200
    ${data_results}    Set Variable    ${resp.json()}[results]
    ${data_length}=    get length       ${data_results}
    Should Be True    ${data_length} == 1
    Should Be Equal    ${resp.json()}[results][0][bankName]    Kshlerin - Ledner Bank

gets a bank account
    POST    ${api}/testData/seed
    Create Session    alias    ${api}/login
    POST On Session    alias    ${api}/login    params=username=Tavares_Barrows&password=s3cret 
    ${resp}=    GET On Session    alias    ${api}/bankAccounts/lWfxENA5ZNy
    ${status_code}    Convert To String       ${resp.status_code}
    Should Be Equal    ${status_code}    200
    Log To Console    ${resp.json()}
    ${data_results}    Set Variable    ${resp.json()}[account]
    Should Be Equal    ${data_results}[bankName]    Kshlerin - Ledner Bank