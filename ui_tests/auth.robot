*** Settings ***
# Import necessary libraries for browser automation, dialog handling, and making HTTP requests
Library    Browser
Library    RequestsLibrary

*** Variables ***
# Define base URL, API endpoint, and test user information
${host}     http://localhost:3000  # Base URL of the application
${api}     http://localhost:3001  # Base URL of the API
# Dictionary containing test user information
&{userInfo}  firstName=Bob    lastName=Ross    username=PainterJoy90    password=s3cret

*** Settings ***
# Perform a POST request to seed the database with test data before each test case
Test Setup    POST    ${api}/testData/seed

*** Test Cases ***
# Test 1: Verify unauthenticated user gets redirected to login page
should redirect unauthenticated user to signin page
    # Open the browser and navigate to the "personal" page
    Open Browser    ${host}/personal

    # Verify the current URL is the login page
    Get Url    equals    ${host}/signin

# Test 2: Verify login functionality
should redirect to the home page after login
    # Open the browser and navigate to the login page
    Open Browser    ${host}/signin

    Login user    Katharina_Bernier    s3cret

    # Verify the current URL is the home page
    Get Url    equals    ${host}/

# Test 3: Verify remember a user after login
should remember a user after login
    # Open the browser and navigate to the login page
    Open Browser    ${host}/signin

    Login user    Katharina_Bernier    s3cret 

    # Wait until the network activity settles, without this wait, cookie is not captured
    Wait Until Network Is Idle    timeout=3s

    # Extract "connect.sid" cookie
    ${cookie}=       Get Cookie    connect.sid
    # Assert that the cookie's expiration year is 1969 (e.g., not set)
    Should Be Equal   ${cookie.expires.year}     ${1969}
    # Click the "Sign out" button from the navigation bar
    Click    css=[data-test="sidenav-signout"]
    # Verify the current URL is the login page after successful logout
    Get Url    equals    ${host}/signin


# Test 4: Verify signup, login, onboarding, and logout flow
should allow a visitor to sign-up, login, and logout
    # Open the browser and navigate to the root page
    Open Browser    ${host}/
    
    # Click the "Sign Up" link, handling potential navigation issues
    Click    xpath=//a[@href="/signup"]
    ${current_url} =    Get Url
    Run Keyword If    "${current_url}" != "${host}/signup"
        # If not on signup page, click again
        ...  Click    xpath=//a[@href="/signup"]
    ...  ELSE
    ...  Log To Console    Current URL is ${host}/signup. No action needed.
    # Verify the "Sign Up" title is present
    Get Text    css=[data-test="signup-title"]    contains    Sign Up

    # Fill first name
    Fill Text    css=#firstName   ${userInfo}[firstName]
    # Fill last name
    Fill Text    css=#lastName    ${userInfo}[lastName]
    # Fill username
    Fill Text    css=#username    ${userInfo}[username]
    # Fill password
    Fill Text    css=#password    ${userInfo}[password]
    # Confirm password (assuming the same as password)
    Fill Text    css=#confirmPassword    ${userInfo}[password]

    # Send the user account creation request and wait for response
    ${promise} =  Promise To   Wait For Response  matcher=${api}/users    timeout=10s
    Click    css=[data-test="signup-submit"]
    Wait For  ${promise}
    # Printing the intercepted API Status/REQ/RESP
    Log To Console    ${promise.result().status}
    Log To Console    ${promise.result().request.postData}
    Log To Console    ${promise.result().body}

    # Login with the newly created user
    Login user    ${userInfo}[username]    ${userInfo}[password]

    # Wait for onboarding dialog and UI elements to appear/disappear indicating successful login
    Wait For Elements State    css=[data-test="user-onboarding-dialog"]    visible    timeout=5 s
    Wait For Elements State    css=[data-test="list-skeleton"]    detached    timeout=5 s
    Wait For Elements State    css=[data-test="nav-top-notifications-count"]    attached    timeout=5 s
    # Click "Next" button on the onboarding dialog
    Click    css=[data-test="user-onboarding-next"]
    # Verify the onboarding dialog title indicates "Create Bank Account"
    Get Text    css=[data-test="user-onboarding-dialog-title"]    contains    Create Bank Account

    # Fill the bank account information in the onboarding dialog
    Fill Text    css=#bankaccount-bankName-input    The Best Bank
    Fill Text    css=#bankaccount-routingNumber-input   123456789
    Fill Text    css=#bankaccount-accountNumber-input   987654321
    # Send the bank account creation request and wait for response
    ${promise} =  Promise To   Wait For Response  matcher=${api}/graphql    timeout=10s
    Click    css=[data-test="bankaccount-submit"]
    Wait For  ${promise}
    #Printing the intercepted API Status/REQ/RESP
    Log To Console    ${promise.result().status}
    Log To Console    ${promise.result().request.postData}
    Log To Console    ${promise.result().body}
    # Verify the onboarding dialog title indicates "Finished"
    Get Text    css=[data-test="user-onboarding-dialog-title"]    contains    Finished
    # Verify the onboarding dialog content mentions "You're all set!"
    Get Text    css=[data-test="user-onboarding-dialog-content"]    contains    You're all set!
     # Click "Next" button on the onboarding dialo
    Click    css=[data-test="user-onboarding-next"]
     # Wait for the transaction list element to become visible, indicating successful onboarding
    Wait For Elements State    css=[data-test="transaction-list"]    visible    timeout=5 s
    # Click the "Sign out" button from the navigation bar
    Click    css=[data-test="sidenav-signout"]
    # Verify the current URL is the login page after successful logout
    Get Url    equals    ${host}/signin

# Test 5: Verify display login errors
should display login errors
    Open Browser    ${host}/

    Fill Text    id=username    User
    Clear Text    id=username
    Focus    id=password
    Wait For Elements State    css=#username-helper-text    visible    timeout=5 s
    Get Text    css=#username-helper-text    contains    Username is required

    Fill Text    id=password    abc
    Focus    id=username
    Wait For Elements State    css=#password-helper-text    visible    timeout=5 s
    Get Text    css=#password-helper-text    contains    Password must contain at least 4 characters
    Wait For Elements State    css=[data-test="signin-submit"]    disabled    timeout=5 s

# Test 6: Verify display signup errors
should display signup errors
    Open Browser    ${host}/signup
    Fill Text    css=#firstName    User
    Clear Text    css=#firstName
    Focus    css=#lastName
    Wait For Elements State    css=#firstName-helper-text  visible    timeout=5 s
    Get Text    css=#firstName-helper-text    contains    First Name is required

    Fill Text    css=#lastName    Last
    Clear Text    css=#lastName
    Focus    css=#username
    Wait For Elements State    css=#lastName-helper-text  visible    timeout=5 s
    Get Text    css=#lastName-helper-text    contains    Last Name is required

    Fill Text    css=#username    Last
    Clear Text    css=#username
    Focus    css=#password
    Wait For Elements State    css=#username-helper-text  visible    timeout=5 s
    Get Text    css=#username-helper-text    contains    Username is required

    Fill Text    css=#password    password
    Clear Text    css=#password
    Focus    css=#confirmPassword
    Wait For Elements State    css=#password-helper-text  visible    timeout=5 s
    Get Text    css=#password-helper-text    contains    Enter your password    

    Fill Text    css=#confirmPassword    DIFFERENT PASSWORD
    Focus    css=#password
    Wait For Elements State    css=#confirmPassword-helper-text  visible    timeout=5 s
    Get Text    css=#confirmPassword-helper-text    contains    Password does not match 

    Wait For Elements State    css=[data-test="signup-submit"]    disabled    timeout=5 s

# Test 7: Verify invalid user error
should error for an invalid user
    Open Browser    ${host}/signin

    Login user    invalidUserName    invalidPa$$word

    Wait For Elements State    css=[data-test="signin-error"]    visible    timeout=5 s
    Get Text    css=[data-test="signin-error"]    contains    Username or password is invalid

# Test 8: Verify invalid password for existing user error
should error for an invalid password for existing user
    Open Browser    ${host}/signin

    Login user    Tavares_Barrows    INVALID

    Wait For Elements State    css=[data-test="signin-error"]    visible    timeout=5 s
    Get Text    css=[data-test="signin-error"]    contains    Username or password is invalid

*** Keywords ***
Login user
    [Arguments]    ${password}    ${username}
    [Documentation]    This keyword Logins User
    # Fill in username and password
    Fill Text    id=username    ${password}
    Fill Text    id=password    ${username}
    # Click the "Sign In" button using its xpath
    ${element} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click    ${element}