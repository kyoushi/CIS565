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
    # Find Transaction by senderId     ${user2}[id]   
    # Log To Console  A
    Fill Text    css=#username   ${user1}[username]
    Fill Text    css=#password   s3cret
    Click    css=[data-test="signin-submit"]
    ${all_transactions}    Get Results From Api    ${api}/testData/transactions
    ${sender_transactions}    Query Json    ${all_transactions}    senderId    ${user2}[id]
    ${transaction_id}    Set Variable    ${sender_transactions}[0][id]
     ${promise} =  Promise To   Wait For Response  matcher=${api}/notifications    timeout=10s
    Go To    ${host}/transaction/${transaction_id}
    Wait For  ${promise}
    ${notfications_results}    Set Variable    ${promise.result().body.results}
    ${notification_size}    Get Json Length    ${notfications_results}
    ${ui_notification_size} =    Get Text    css=[data-test="nav-top-notifications-count"]
    Should be equal            (${notification_size})   (${ui_notification_size})
    Get Text    css=[data-test*=transaction-like-count]    equals    0
    Click    css=[data-test*=transaction-like-button]
    Get Attribute Names       css=[data-test*=transaction-like-button]    contains    disabled
    Get Text    css=[data-test*=transaction-like-count]    equals    1
    Click    css=[data-test="sidenav-signout"]
    Get Url    equals    ${host}/signin
    Fill Text    css=#username   ${user2}[username]
    Fill Text    css=#password   s3cret
    ${promise} =  Promise To   Wait For Response  matcher=${api}/notifications    timeout=10s
    Click    css=[data-test="signin-submit"]
    Wait For  ${promise}
    Go To    ${host}/notifications
    ${notfications_results}    Set Variable    ${promise.result().body.results}
    ${notification_size}    Get Json Length    ${notfications_results}
    ${ui_notification_size} =    Get Text    css=[data-test="nav-top-notifications-count"]
    Should be equal            (${notification_size})   (${ui_notification_size})
    ${ui_notifications} =    Get Elements    css=[data-test*=notification-list-item]
    Get Text    ${ui_notifications}[0]    contains    ${user1}[firstName]
    Get Text    ${ui_notifications}[0]    contains    liked
    ${ui_dissmiss} =    Get Elements    css=[data-test*="notification-mark-read"]
    Click    ${ui_dissmiss}[0]
    Get Text    css=[data-test="nav-top-notifications-count"]    <    ${ui_notification_size}

*** Keywords ***
Run Multiple Test Setup Steps
    POST    ${api}/testData/seed
    ${resp}=    GET    ${api}/testData/users
    ${data_results}    Set Variable    ${resp.json()}[results]
    ${data_length}=    get length       ${data_results}
    Set Test Variable    ${user1}    ${data_results}[0]
    Set Test Variable    ${user2}    ${data_results}[1]
    Set Test Variable    ${user3}    ${data_results}[2]
