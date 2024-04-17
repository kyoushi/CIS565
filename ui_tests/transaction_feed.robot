*** Settings ***
Library     Browser
Library     RequestsLibrary


*** Variables ***
${BASE_URL}                    http://localhost:3000
${BACKEND_URL}                 http:/localhost:3001  
${Public_List_XPath}           //*[@id="root"]/div/header/div[2]/div/div/a[1]/span[1]
${Transaction_List_XPath}      //*[@id="root"]/div/main/div[2]/div
${Contact_List_XPath}           //*[@id="root"]/div/header/div[2]/div/div/a[2]/span[1]
${List_Type_XPath}               //*[@id="root"]/div/main/div[2]/div/div/div/div[2]

${Personal_List_XPath}          //*[@id="root"]/div/header/div[2]/div/div/a[3]/span[1]
${Paid_Contact_XPath}           //*[@id="root"]/div/main/div[2]/div/div/div/div[3]/div/div/div[1]/li/div/div/div[2]/div[1]/div
${Action_Type_XPath}                  //*[@id="root"]/div/main/div[2]/div/div/div/div[1]/div[1]/div[2]/div[2]/p/span[2]


*** Test Cases ***
should redirect to transaction feeds page on logging in

    Open Browser    ${BASE_URL}/signin
    Fill Text      id=username      Katharina_Bernier
    Fill Text      id=password      s3cret  
    ${Sign_in} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click   ${Sign_In}
    Get Url         equals          http://localhost:3000/

Transaction feed app layout should be responsive

    Open Browser    ${BASE_URL}/signin
    Fill Text      id=username      Katharina_Bernier
    Fill Text      id=password      s3cret  
    ${Sign_in} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click   ${Sign_In}

    ${Side_Nav} =       Get Element      xpath=//*[@id="root"]/div/div
    ${Menu_Button} =        Get Element     xpath=//*[@id="root"]/div/header/div[1]/button
    Click   ${Menu_Button}

    Get Attribute       ${Side_Nav}     disabled    evaluate    value is not None


Check public transaction list is enabled

    Open Browser    ${BASE_URL}/signin
    Fill Text      id=username      Katharina_Bernier
    Fill Text      id=password      s3cret  
    ${Sign_in} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click   ${Sign_In}

    ${Public_List} =    Get Element     xpath=${Public_List_XPath}\[text()="Everyone"]

    Click   ${Public_List}

    Sleep    0.5s
    Get Attribute       xpath=${Transaction_List_XPath}     disabled        evaluate    value is None

    ${List_Type} =      Get Text     xpath=${List_Type_XPath}

    Should Contain      ${List_Type}        Public

Check contact transaction list is enabled

    Open Browser    ${BASE_URL}/signin
    Fill Text      id=username      Katharina_Bernier
    Fill Text      id=password      s3cret  
    ${Sign_in} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click   ${Sign_In}

    ${Contact_List} =    Get Element     xpath=${Contact_List_XPath}\[text()="Friends"]

    Click   ${Contact_List}

    Sleep    0.5s
    Get Attribute       xpath=${Transaction_List_XPath}        disabled        evaluate    value is None

    ${List_Type} =      Get Text     xpath=${List_Type_XPath}

    Should Contain      ${List_Type}    Contacts


Check personal transaction list is enabled

    Open Browser    ${BASE_URL}/signin
    Fill Text      id=username      Katharina_Bernier
    Fill Text      id=password      s3cret  
    ${Sign_in} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click   ${Sign_In}

    ${Personal_List} =    Get Element     xpath=${Personal_List_XPath}\[text()="Mine"]

    Click   ${Personal_List}

    Sleep    0.5s
    Get Attribute       xpath=${Transaction_List_XPath}         disabled        evaluate    value is None

    ${List_Type} =      Get Text     xpath=${List_Type_XPath}

    Should Contain      ${List_Type}    Personal

should render transaction type variations in the feed

    Open Browser    ${BASE_URL}/signin
    Fill Text      id=username      Katharina_Bernier
    Fill Text      id=password      s3cret  
    ${Sign_in} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click   ${Sign_In}

    Sleep    0.5s
    ${Action_Type} =        Get Text        xpath= //*[@id="root"]/div/main/div[2]/div/div/div/div[3]/div/div/div[1]/li/div/div/div[2]/div[1]/div/p[1]/span[2]

    ${Sender} =       Get Text        xpath= //*[@id="root"]/div/main/div[2]/div/div/div/div[3]/div/div/div[1]/li/div/div/div[2]/div[1]/div/p[1]/span[1]

    ${Receiver} =         Get Text        xpath= //*[@id="root"]/div/main/div[2]/div/div/div/div[3]/div/div/div[1]/li/div/div/div[2]/div[1]/div/p[1]/span[3]

    ${Likes} =        Get Text        xpath= //*[@id="root"]/div/main/div[2]/div/div/div/div[3]/div/div/div[1]/li/div/div/div[2]/div[1]/div/div/div[2]/p

    ${Comments} =         Get Text        xpath= //*[@id="root"]/div/main/div[2]/div/div/div/div[3]/div/div/div[1]/li/div/div/div[2]/div[1]/div/div/div[4]/p


    Should Contain    ${Action_Type}    paid
    Should Contain    ${Sender}         Kaylin Homenick
    Should Contain    ${Receiver}       Arely Kertzmann
    Should Contain    ${Likes}          0
    Should Contain    ${Comments}       0


should be able to accept the transaction request

    Open Browser    ${BASE_URL}/signin
    Fill Text      id=username      Katharina_Bernier
    Fill Text      id=password      s3cret  
    ${Sign_in} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click   ${Sign_In}

    Sleep    0.5s

    ${Personal_List} =    Get Element     xpath=${Personal_List_XPath}\[text()="Mine"]

    Click   ${Personal_List}

    Sleep      1s

    Hover       xpath=//*[@id="root"]/div/main/div[2]/div/div/div/div[3]/div/div/div[2]        
    Mouse Wheel     20000       0    # re-visit , unable to scroll to required position
    Sleep        4s
    
            
should be able to select a date range

    Open Browser    ${BASE_URL}/signin
    Fill Text      id=username      Katharina_Bernier
    Fill Text      id=password      s3cret  
    ${Sign_in} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click   ${Sign_In}

    Sleep    0.5s

    ${Date_Widget} =    Get Element         xpath=//*[@id="root"]/div/main/div[2]/div/div/div/div[1]/div/div[1]/div/div/span[1]

    Click   ${Date_Widget}   
    Sleep   0.5s

    ${Start_Date} =     Get Element         xpath=//*[@id="date-range-popover"]/div[3]/div/div[2]/div/div[2]/div/div[3]/div/ul[3]/li[6]
    Click   ${Start_Date}
    
    ${End_Date} =     Get Element         xpath=//*[@id="date-range-popover"]/div[3]/div/div[2]/div/div[2]/div/div[3]/div/ul[4]/li[1]
    Click   ${End_Date}

    Sleep    0.5s
    Get Attribute       xpath=${Transaction_List_XPath}         disabled        evaluate    value is not None


should be able to set the amount range

    Open Browser    ${BASE_URL}/signin
    Fill Text      id=username      Katharina_Bernier
    Fill Text      id=password      s3cret  
    ${Sign_in} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click   ${Sign_In}

    Sleep    0.5s


    ${Amount_Widget} =      Get Element         xpath=//*[@id="root"]/div/main/div[2]/div/div/div/div[1]/div/div[2]/div/div/span[1]

    Click      ${Amount_Widget}

    Hover       xpath=//*[@id="amount-range-popover"]/div[3]/div/div[2]/span/span[3]
    Mouse button        down
    Mouse Move Relative To          xpath=//*[@id="amount-range-popover"]/div[3]/div/div[2]/span/span[3]        30 
    Mouse button        up
    
    Sleep       2s

    Get Attribute       xpath=${Transaction_List_XPath}         disabled        evaluate    value is not None

    