*** Settings ***
# Import necessary libraries for browser automation, dialog handling, and making HTTP requests
Library    RequestsLibrary
Library    ./lib/CustomLib.py
Library    Collections

*** Variables ***
# Define base URL, API endpoint, and test user information
${api}     http://localhost:3001  # Base URL of the API

*** Test Cases ***
gets a list of notifications for a user
    POST    ${api}/testData/seed
    Create Session    alias    ${api}/login
    POST On Session    alias    ${api}/login    params=username=Tavares_Barrows&password=s3cret 
    ${resp}=    GET On Session    alias    ${api}/notifications
    ${status_code}    Convert To String       ${resp.status_code}
    Should Be Equal    ${status_code}    200
    ${data_results}    Set Variable    ${resp.json()}[results]
    ${data_length}=    get length       ${data_results}
    Should Be True    ${data_length} > 0

creates notifications for transaction, like and comment
    POST    ${api}/testData/seed
    Create Session    alias    ${api}/login
    POST On Session    alias    ${api}/login    params=username=Tavares_Barrows&password=s3cret 
    ${body}=    Evaluate    json.loads($json_string)    json
    ${resp}=   POST On Session    alias    ${api}/notifications/bulk    json=${body}
    ${status_code}    Convert To String       ${resp.status_code}
    Should Be Equal    ${status_code}    200
    ${data_results}    Set Variable    ${resp.json()}[results]
    ${data_length}=    get length       ${data_results}
    Should Be True    ${data_length} == 3
    Should Be Equal    ${body}[items][0][transactionId]    ${resp.json()}[results][0][transactionId]


*** Variables ***
${json_string}    {"items": [{"type": "payment", "transactionId": "CYsWTTXPOOKx", "status": "received"},{"type": "like", "transactionId": "WIHpqM0xpcTx", "likeId": "MC54o2D5r9aU"},{"type": "comment", "transactionId": "6MCm9R1dkLk_", "commentId": "YarNHJR_5Rh6"}]}