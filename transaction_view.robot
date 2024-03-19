*** Settings ***
Library     Browser
Library     RequestsLibrary


*** Variables ***
${BASE_URL}                    http://localhost:3000
${BACKEND_URL}                 http:/localhost:3001  
${Personal_List_XPath}          //*[@id="root"]/div/header/div[2]/div/div/a[3]/span[1]

*** Test Cases ***

should be able to retrieve hidden transaction view

    Open Browser    ${BASE_URL}/signin
    Fill Text      id=username      Katharina_Bernier
    Fill Text      id=password      s3cret  
    ${Sign_in} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click   ${Sign_In}
    

    ${Personal_List} =    Get Element     xpath=${Personal_List_XPath}\[text()="Mine"]

    Click   ${Personal_List}

    ${Transaction} =    Get Element    xpath=//*[contains(@data-test, "transaction-item--7xanIywv9x")]

    ${data_test_value} =    Get Attribute        ${Transaction}    data-test


    ${split_value} =    Split String By Delimiter    ${data_test_value}    --
    ${extracted_value} =    Set Variable    ${split_value}[1]
    
    Click       ${Transaction}  

    Get Url         contains       ${extracted_value} 



should be able to like a transaction
    Open Browser    ${BASE_URL}/signin
    Fill Text      id=username      Katharina_Bernier
    Fill Text      id=password      s3cret  
    ${Sign_in} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click   ${Sign_In}
    

    ${Personal_List} =    Get Element     xpath=${Personal_List_XPath}\[text()="Mine"]
    Click   ${Personal_List}

    ${Transaction} =    Get Element    xpath=//*[contains(@data-test, "transaction-item--7xanIywv9x")]
    Click       ${Transaction}


    ${Like_Button} =        Get Element         xpath=//*[@id="root"]/div/main/div[2]/div/div/div/div[2]/div/div[1]/div[2]
    Click   ${Like_Button}

    ${element} =    Get Element     xpath=//*[@id="root"]/div/main/div[2]/div/div/div/div[2]/div/div[1]/div[1]

    ${like_count} =    Get Text    ${element}
    ${like_count_integer} =    Convert To Integer    ${like_count}
    Should Be True    ${like_count_integer} >= 1


Should be able to comment on a transaction
    Open Browser    ${BASE_URL}/signin
    Fill Text      id=username      Katharina_Bernier
    Fill Text      id=password      s3cret  
    ${Sign_in} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click   ${Sign_In}
    

    ${Personal_List} =    Get Element     xpath=${Personal_List_XPath}\[text()="Mine"]
    Click   ${Personal_List}

    ${Transaction} =    Get Element    xpath=//*[contains(@data-test, "transaction-item--7xanIywv9x")]Click       ${Transaction}

    Fill Text       id=transaction-comment-input--7xanIywv9x        alright
    Keyboard Key       press        Enter

    
    ${comment_items} =    Get Elements    xpath=//*[@id="root"]/div/main/div[2]/div/div/div/div[3]/ul
    Should Not Be Empty    ${comment_items}


*** Keywords ***
Split String By Delimiter
    [Arguments]    ${string}    ${delimiter}
    ${result} =    Evaluate    $string.split($delimiter)
    [Return]    ${result}