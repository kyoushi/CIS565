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
    # Fill in username and password
    Fill Text    id=username    Katharina_Bernier
    Fill Text    id=password    s3cret
    # Click the "Sign In" button using its xpath
    ${element} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click    ${element}
    # Verify the current URL is the home page
    Get Url    equals    ${host}/

# Test 3: Verify signup, login, onboarding, and logout flow
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
    Fill Text    css=#username   ${userInfo}[username]
    Fill Text    css=#password   ${userInfo}[password]
    Click    css=[data-test="signin-submit"]
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
