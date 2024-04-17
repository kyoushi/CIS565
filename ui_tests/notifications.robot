*** Settings ***
# Import necessary libraries for browser automation, dialog handling, and making HTTP requests
Library    Browser
Library    Dialogs
Library    RequestsLibrary
Library    ./lib/CustomLib.py

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
    Fill up Login   ${user1}[username]    s3cret
    Click    css=[data-test="signin-submit"]
    ${transaction_id}=    Get latest transaction given a sender    ${user2}

    ${promise} =  Promise To   Wait For Response  matcher=${api}/notifications    timeout=10s
    Go To    ${host}/transaction/${transaction_id}
    Wait For  ${promise}
    
    Verify Notification count API matches UI   ${promise} 
    Verify Like Transaction Functionality

    Click    css=[data-test="sidenav-signout"]
    Get Url    equals    ${host}/signin
    Fill up Login   ${user2}[username]    s3cret

    ${promise} =  Promise To   Wait For Response  matcher=${api}/notifications    timeout=10s
    Click    css=[data-test="signin-submit"]
    Wait For  ${promise}

    Go To    ${host}/notifications

    Verify Notification count API matches UI   ${promise} 
    Verify User B gets notification that User A liked transaction
    Verify User B can dismiss notification

    

*** Keywords ***
Run Multiple Test Setup Steps
    POST    ${api}/testData/seed
    ${resp}=    GET    ${api}/testData/users
    ${data_results}    Set Variable    ${resp.json()}[results]
    ${data_length}=    get length       ${data_results}
    Set Test Variable    ${user1}    ${data_results}[0]
    Set Test Variable    ${user2}    ${data_results}[1]
    Set Test Variable    ${user3}    ${data_results}[2]

Get latest transaction given a sender
    [Arguments]    ${user}
    ${all_transactions}    Get Results From Api    ${api}/testData/transactions
    ${sender_transactions}    Query Json    ${all_transactions}    senderId    ${user}[id]
    [return]    ${sender_transactions}[0][id]

Fill up Login
    [Arguments]    ${password}    ${username}
    [Documentation]    This keyword Fills up Login Page
    Fill Text    css=#username   ${password}
    Fill Text    css=#password   ${username}

Verify Notification count API matches UI
    [Arguments]    ${promise}
    ${notfications_results}    Set Variable    ${promise.result().body.results}
    ${notification_size}    Get Json Length    ${notfications_results}
    ${ui_notification_size} =    Get Text    css=[data-test="nav-top-notifications-count"]
    Should be equal            (${notification_size})   (${ui_notification_size})

Verify Like Transaction Functionality
    [Documentation]    This keyword Verifies that Like Count is increased by 1 when Like button is clicked and button gets disabled
    Get Text    css=[data-test*=transaction-like-count]    equals    0
    Click    css=[data-test*=transaction-like-button]
    Get Attribute Names       css=[data-test*=transaction-like-button]    contains    disabled
    Get Text    css=[data-test*=transaction-like-count]    equals    1

Verify User B gets notification that User A liked transaction
    [Documentation]    This keyword Verifies that User B gets notification that User A liked transaction
    ${ui_notifications} =    Get Elements    css=[data-test*=notification-list-item]
    Get Text    ${ui_notifications}[0]    contains    ${user1}[firstName]
    Get Text    ${ui_notifications}[0]    contains    liked

Verify User B can dismiss notification
    [Documentation]    This keyword Verifies that User B can dismiss notification
    ${ui_notification_size} =    Get Text    css=[data-test="nav-top-notifications-count"]
    ${ui_dissmiss} =    Get Elements    css=[data-test*="notification-mark-read"]
    Click    ${ui_dissmiss}[0]
    Get Text    css=[data-test="nav-top-notifications-count"]    <    ${ui_notification_size}