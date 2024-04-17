*** Settings ***
Library    Browser
Library    RequestsLibrary

*** Variables ***
${BASE_URL}                    http://localhost:3000
${BACKEND_URL}                 http://localhost:3001
${New_Transaction_XPath}       //*[@id="root"]/div/header/div/a[1]
${Search_Contact_XPath}        //*[@id="user-list-search-input"]
${Search_Contact_List_XPath}   //*[@id="root"]/div/main/div[2]/div/div/div[2]/ul
${Contact_List_XPath}          //*[@id="root"]/div/main/div[2]/div/div/div[2]/ul/li[1]/div[2]/span
${Request_Amount_XPath}        //*[@id="root"]/div/main/div[2]/div/div/div[2]/div[2]/form/div[3]/div[1]
${Pay_Amount_XPath}            //*[@id="root"]/div/main/div[2]/div/div/div[2]/div[2]/form/div[3]/div[2]
${Amount_Paid_XPath}           //*[@id="root"]/div/main/div[2]/div/div/div[2]/div[2]/div/div/h2
${Expected_Placeholder_Value}  Search...
${Account_Balance}             //*[@id="root"]/div/div/div/div[2]/div[1]/h6[1]
&{User_Info}                   firstName=Bob    lastName=Ross    username=PainterJoy90    password=s3cret
${TRANSACTION_PAYLOAD}    transactionType=request    amount=100    description=Fancy Hotel
${SEARCH_ATTRIBUTES}    firstName    lastName    username    email    phoneNumber

*** Test Cases ***
should redirect to new transaction page on clicking new button on nav bar
    Open Browser    ${BASE_URL}/signin
    Fill Text    id=username    Katharina_Bernier    
    Fill Text    id=password    s3cret   
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click    ${Sign_in}
    ${New_Transaction} =    Get Element   xpath=${New_Transaction_XPath}
    Click    ${New_Transaction}   
    Get Url       equals       http://localhost:3000/transaction/new

new transaction page should have a search bar to select an account
    Open Browser    ${BASE_URL}/signin
    Fill Text    id=username    Katharina_Bernier    
    Fill Text    id=password    s3cret   
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click    ${Sign_in}
    ${New_Transaction} =    Get Element    xpath=${New_Transaction_XPath}
    Click    ${New_Transaction}
    
    ${Actual_Placeholder} =    Get Attribute    ${Search_Contact_XPath}    placeholder
    Should Be Equal    ${Actual_Placeholder}    ${Expected_Placeholder_Value}    msg=Placeholder value does not match expected value

should show the contact name on typing in the search bar
    Open Browser    ${BASE_URL}/signin
    Fill Text    id=username    Katharina_Bernier    
    Fill Text    id=password    s3cret   
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click    ${Sign_in}
    ${New_Transaction} =    Get Element    xpath=${New_Transaction_XPath}
    Click    ${New_Transaction}

    Fill Text    id=user-list-search-input    Arely Kertzmann
    ${CONTACT_NAME} =    Get Text    xpath=${Contact_List_XPath}

    Should Be Equal    Arely Kertzmann    ${CONTACT_NAME}    msg=Contact name does not match expected value


should be able submit a transaction payment

    Open Browser    ${BASE_URL}/signin
    Fill Text    id=username    Katharina_Bernier    
    Fill Text    id=password    s3cret   
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click    ${Sign_in}
    ${New_Transaction} =    Get Element    xpath=${New_Transaction_XPath}
    Click    ${New_Transaction}

    Fill Text    id=user-list-search-input    Arely Kertzmann
    ${CONTACT_NAME} =    Get Element    xpath=${Contact_List_XPath}
    Click    ${CONTACT_NAME}

    ${Amount_Before_Deduction} =    Get Text    xpath=${Account_Balance}
    Fill Text    id=amount  15
    Fill Text    id=transaction-create-description-input    Rent

    ${Pay_Button} =    Get Element    xpath=${Pay_Amount_XPath}/button/span[text()="Pay"]
    Click    ${Pay_Button}

    ${Amount Paid} =    Get Text    xpath=${Amount_Paid_XPath}
    Sleep    0.5s
    ${Amount_After_Deduction} =     Get Text    xpath=${Account_Balance}
    
    ${amount_before} =    Convert To Number        ${Amount_Before_Deduction.split('$')[1].replace(',', '')}   
    ${amount_after} =    Convert To Number         ${Amount_After_Deduction.split('$')[1].replace(',', '')}   

    Should Be True    ${amount_before} > ${amount_after}
    Should Contain    ${Amount Paid}    Paid $15
    


should be able to place a transaction Request

    Open Browser    ${BASE_URL}/signin
    Fill Text    id=username    Katharina_Bernier    
    Fill Text    id=password    s3cret   
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click    ${Sign_in}
    ${New_Transaction} =    Get Element    xpath=${New_Transaction_XPath}
    Click    ${New_Transaction}

    Fill Text    id=user-list-search-input    Arely Kertzmann
    ${CONTACT_NAME} =    Get Element    xpath=${Contact_List_XPath}
    Click    ${CONTACT_NAME}

    Fill Text    id=amount  45
    Fill Text    id=transaction-create-description-input    Groceries

    ${Request_Button} =    Get Element    xpath=${Request_Amount_XPath}/button/span[text()="Request"]
    Click    ${Request_Button}

    ${Amount_Requested} =    Get Text    xpath=${Amount_Paid_XPath}

    Should Contain    ${Amount_Requested}    Requested $45


Searches For User By Attribute
    [Documentation]    This test searches for a user by different attributes

    Open Browser    ${BASE_URL}/signin
    Fill Text    id=username    Katharina_Bernier
    Fill Text    id=password    s3cret
    Click    xpath=//button/span[text()="Sign In"]
    ${New_Transaction} =    Get Element    xpath=${New_Transaction_XPath}
    Click    ${New_Transaction}

    @{searchAttrs}    Create List    firstName    lastName    username    email    phoneNumber
    FOR    ${attr}    IN    @{searchAttrs}
        Search User By Attribute    ${attr}
    END


Display New Transaction Errors
    [Documentation]    This test verifies that new transaction errors are displayed

    Open Browser    ${BASE_URL}/signin
    Fill Text    id=username    Katharina_Bernier
    Fill Text    id=password    s3cret
    Click    xpath=//button/span[text()="Sign In"]

    ${New_Transaction} =    Get Element    xpath=${New_Transaction_XPath}
    Click    ${New_Transaction}
    Click    ${Contact_List_XPath}

    ${submit_request_button}=    Get Element    xpath=${Request_Amount_XPath}/button/span[text()="Request"]
    ${submit_payment_button}=    Get Element    xpath=${Pay_Amount_XPath}/button/span[text()="Pay"]

    Get Attribute    ${submit_request_button}    disabled    evaluate    value is not None  
    Get Attribute    ${submit_payment_button}    disabled    evaluate    value is not None  




*** Keywords ***
Search User By Attribute
    [Arguments]    ${attr}
    [Documentation]    This keyword searches for a user by the specified attribute
    ${targetUser}=    Create User    ${attr}
    Log    Searching by **${attr}**
    Fill Text    id=user-list-search-input    ${targetUser["${attr}"]}
    
    ${resultsN}=    Get Element Count    xpath=${Search_Contact_XPath}
    Log    Found ${resultsN} user list items
    Should Be True    ${resultsN} > 0
    

Create User
    [Arguments]    ${attr}
    [Documentation]    This keyword creates a simulated user based on the specified attribute
    ${user}=    Create Dictionary    firstName=Devon    lastName=Becker    username=Jessyca.Kuhic    email=Jordy37@yahoo.com    phoneNumber=277-189-3402
    [Return]    ${user}

