*** Settings ***
Library     Browser

***Variables***
&{Login_Info}       username=Katharina_Bernier    password=s3cret
${Bank_Accounts_XPath}     //*[@id="root"]/div/div/div/div[2]/div[3]/ul/div/a[3]
${Bank_Account_Header_XPath}    //*[@id="root"]/div/main/div[2]/div/div/div/div/div[1]/h2 
${Create_Bank_Account_XPath}    //*[@id="root"]/div/main/div[2]/div/div/div/div/div[2]/a
${Delete_Bank_Account_XPath}    //*[@id="root"]/div/main/div[2]/div/div/div/ul/li[1]/div/div[2]/button
${Create_New_Bank_Name_XPath}   //*[@id="bankaccount-bankName-input"]
${Create_New_Routing_Num_XPath}     //*[@id="bankaccount-routingNumber-input"]
${Create_New_Account_Num_XPath}     //*[@id="bankaccount-accountNumber-input"]
${Create_New_Bank_Name_Helper_XPath}    //*[@id="bankaccount-bankName-input-helper-text"]
${Create_New_Bank_Routing_Helper_XPath}    //*[@id="bankaccount-routingNumber-input-helper-text"]
${Create_New_Bank_Account_Helper_XPath}    //*[@id="bankaccount-accountNumber-input-helper-text"]
${Click_Off_TB_XPath}         //*[@id="root"]/div/main/div[2]/div/div
${Save_Button_XPath}          //*[@id="root"]/div/main/div[2]/div/div/div/form/div[4]/div/button/span[1]
${Accounts_List}            //*[@id="root"]/div/main/div[2]/div/div/div/ul/li

*** Test Cases ***
should redirect to the Bank Accounts page after selecting Bank Accounts on the side bar
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click       ${Sign_in}
    ${Bank_Accounts_Button} =   Get Element     xpath=${Bank_Accounts_XPath}
    Click       ${Bank_Accounts_Button}
    ${Header} =     Get Element     xpath=${Bank_Account_Header_XPath}
    Get Url     equals      http://localhost:3000/bankaccounts
    Get Text    ${Header}   equals      Bank Accounts

Bank Account Page should have button to create new bank account
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click       ${Sign_in}
    ${Bank_Accounts_Button} =   Get Element     xpath=${Bank_Accounts_XPath}
    Click       ${Bank_Accounts_Button}
    ${Create_Button} =      Get Element         xpath=${Create_Bank_Account_XPath}
    Get Text    ${Create_Button}        equals      CREATE

Bank Account Page should have button to delete bank account
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click       ${Sign_in}
    ${Bank_Accounts_Button} =   Get Element     xpath=${Bank_Accounts_XPath}
    Click       ${Bank_Accounts_Button}
    ${Delete_Button} =      Get Element         xpath=${Delete_Bank_Account_XPath}
    Get Text    ${Delete_Button}        equals      DELETE

Bank Account Page should redirect the page after hitting create button
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click       ${Sign_in}
    ${Bank_Accounts_Button} =   Get Element     xpath=${Bank_Accounts_XPath}
    Click       ${Bank_Accounts_Button}
    ${Create_Button} =      Get Element         xpath=${Create_Bank_Account_XPath}
    Click   ${Create_Button}
    Get Url     equals      http://localhost:3000/bankaccounts/new

Create new bank account page should have a helper for the spot to fill in bank name
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click       ${Sign_in}
    ${Bank_Accounts_Button} =   Get Element     xpath=${Bank_Accounts_XPath}
    Click       ${Bank_Accounts_Button}
    ${Create_Button} =      Get Element         xpath=${Create_Bank_Account_XPath}
    Click   ${Create_Button}
    ${Bank_Name} =      Get Element             xpath=${Create_New_Bank_Name_XPath}
    Click       ${Bank_Name}
    ${Click_off} =      Get Element             xpath=${Click_Off_TB_XPath}
    Click       ${Click_off}
    ${Bank_Name_Helper} =      Get Element             xpath=${Create_New_Bank_Name_Helper_XPath}
    Get Text    ${Bank_Name_Helper}     equals      Enter a bank name


Create new bank account page should have a spot that can be filled with bank name
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click       ${Sign_in}
    ${Bank_Accounts_Button} =   Get Element     xpath=${Bank_Accounts_XPath}
    Click       ${Bank_Accounts_Button}
    ${Create_Button} =      Get Element         xpath=${Create_Bank_Account_XPath}
    Click   ${Create_Button}
    ${Bank_Name} =          Get Element         xpath=${Create_New_Bank_Name_XPath}
    Fill Text       ${Bank_Name}        TDAmeritrade
    Get Text        ${Bank_Name}        equals      TDAmeritrade

Create new bank account page should have a helper for minimum bank name length
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click       ${Sign_in}
    ${Bank_Accounts_Button} =   Get Element     xpath=${Bank_Accounts_XPath}
    Click       ${Bank_Accounts_Button}
    ${Create_Button} =      Get Element         xpath=${Create_Bank_Account_XPath}
    Click   ${Create_Button}
    ${Bank_Name} =      Get Element             xpath=${Create_New_Bank_Name_XPath}
    Fill Text       ${Bank_Name}        TD
    ${Bank_Name_Helper} =      Get Element             xpath=${Create_New_Bank_Name_Helper_XPath}
    Get Text    ${Bank_Name_Helper}     equals      Must contain at least 5 characters

Create new bank account page should have a helper for the spot to fill in Routing Number
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click       ${Sign_in}
    ${Bank_Accounts_Button} =   Get Element     xpath=${Bank_Accounts_XPath}
    Click       ${Bank_Accounts_Button}
    ${Create_Button} =      Get Element         xpath=${Create_Bank_Account_XPath}
    Click   ${Create_Button}
    ${Bank_Routing} =      Get Element             xpath=${Create_New_Routing_Num_XPath}
    Click       ${Bank_Routing}
    ${Click_off} =         Get Element             xpath=//*[@id="root"]/div/main/div[2]
    Click           ${Click_off}
    ${Bank_Routing_Helper} =      Get Element             xpath=${Create_New_Bank_Routing_Helper_XPath}
    Get Text    ${Bank_Routing_Helper}     equals      Enter a valid bank routing number

Create new bank account page should have a spot that can be filled with Routing Number
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click       ${Sign_in}
    ${Bank_Accounts_Button} =   Get Element     xpath=${Bank_Accounts_XPath}
    Click       ${Bank_Accounts_Button}
    ${Create_Button} =      Get Element         xpath=${Create_Bank_Account_XPath}
    Click   ${Create_Button}
    ${Bank_Routing} =          Get Element         xpath=${Create_New_Routing_Num_XPath}
    Fill Text       ${Bank_Routing}        123123123
    Get Text        ${Bank_Routing}        equals      123123123

Create new bank account page should have a helper for the Routing number spot to fill a correct account number
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click       ${Sign_in}
    ${Bank_Accounts_Button} =   Get Element     xpath=${Bank_Accounts_XPath}
    Click       ${Bank_Accounts_Button}
    ${Create_Button} =      Get Element         xpath=${Create_Bank_Account_XPath}
    Click   ${Create_Button}
    ${Bank_Routing} =      Get Element             xpath=${Create_New_Routing_Num_XPath}
    Fill Text       ${Bank_Routing}         123
    ${Bank_Routing_Helper} =      Get Element             xpath=${Create_New_Bank_Routing_Helper_XPath}
    Get Text    ${Bank_Routing_Helper}     equals      Must contain a valid routing number

Create new bank account page should have a helper for the Routing number spot to fill a correct account number
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click       ${Sign_in}
    ${Bank_Accounts_Button} =   Get Element     xpath=${Bank_Accounts_XPath}
    Click       ${Bank_Accounts_Button}
    ${Create_Button} =      Get Element         xpath=${Create_Bank_Account_XPath}
    Click   ${Create_Button}
    ${Bank_Routing} =      Get Element             xpath=${Create_New_Routing_Num_XPath}
    Fill Text       ${Bank_Routing}         1231231231
    ${Bank_Routing_Helper} =      Get Element             xpath=${Create_New_Bank_Routing_Helper_XPath}
    Get Text    ${Bank_Routing_Helper}     equals      Must contain a valid routing number


Create new bank account page should have a helper for the spot to fill in Account Number
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click       ${Sign_in}
    ${Bank_Accounts_Button} =   Get Element     xpath=${Bank_Accounts_XPath}
    Click       ${Bank_Accounts_Button}
    ${Create_Button} =      Get Element         xpath=${Create_Bank_Account_XPath}
    Click   ${Create_Button}
    ${Bank_Account_num} =      Get Element             xpath=${Create_New_Account_Num_XPath}
    Click       ${Bank_Account_num}
    ${Click_off} =      Get Element             xpath=${Click_Off_TB_XPath}
    Click       ${Click_off}
    ${Bank_Accounting_Helper} =      Get Element             xpath=${Create_New_Bank_Account_Helper_XPath}
    Get Text    ${Bank_Accounting_Helper}     equals      Enter a valid bank account number

Create new bank account page should have a spot to fill in Account Number
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click       ${Sign_in}
    ${Bank_Accounts_Button} =   Get Element     xpath=${Bank_Accounts_XPath}
    Click       ${Bank_Accounts_Button}
    ${Create_Button} =      Get Element         xpath=${Create_Bank_Account_XPath}
    Click   ${Create_Button}
    ${Bank_Account_num} =      Get Element             xpath=${Create_New_Account_Num_XPath}
    Click       ${Bank_Account_num}
    Fill Text   ${Bank_Account_num}         123123123
    Get Text    ${Bank_Account_num}         equals      123123123

Create new bank account page should have a helper for the bank account number spot for validity checks
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click       ${Sign_in}
    ${Bank_Accounts_Button} =   Get Element     xpath=${Bank_Accounts_XPath}
    Click       ${Bank_Accounts_Button}
    ${Create_Button} =      Get Element         xpath=${Create_Bank_Account_XPath}
    Click   ${Create_Button}
    ${Bank_Account_num} =      Get Element      xpath=${Create_New_Account_Num_XPath}
    Click       ${Bank_Account_num}
    Fill Text   ${Bank_Account_num}         123
    ${Helper_Message} =         Get Element      xpath=${Create_New_Bank_Account_Helper_XPath}
    Get Text    ${Helper_Message}       equals      Must contain at least 9 digits

Create new bank account page should have a helper for the bank account number spot for validity checks
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click       ${Sign_in}
    ${Bank_Accounts_Button} =   Get Element     xpath=${Bank_Accounts_XPath}
    Click       ${Bank_Accounts_Button}
    ${Create_Button} =      Get Element         xpath=${Create_Bank_Account_XPath}
    Click   ${Create_Button}
    ${Bank_Account_num} =      Get Element      xpath=${Create_New_Account_Num_XPath}
    Fill Text   ${Bank_Account_num}         1231231231231
    ${Helper_Message} =         Get Element      xpath=${Create_New_Bank_Account_Helper_XPath}
    Get Text    ${Helper_Message}       equals      Must contain no more than 12 digits

Should be able to Save the new Bank Account
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click       ${Sign_in}
    ${Bank_Accounts_Button} =   Get Element     xpath=${Bank_Accounts_XPath}
    Click       ${Bank_Accounts_Button}
    ${Length} =                   Get Element Count    xpath=${Accounts_List}
    ${Create_Button} =      Get Element         xpath=${Create_Bank_Account_XPath}
    Click   ${Create_Button}
    ${Bank_Name} =          Get Element         xpath=${Create_New_Bank_Name_XPath}
    Fill Text       ${Bank_Name}        TDAmeritrade
    ${Bank_Routing} =          Get Element         xpath=${Create_New_Routing_Num_XPath}
    Fill Text       ${Bank_Routing}        123123123
    ${Bank_Account_num} =      Get Element             xpath=${Create_New_Account_Num_XPath}
    Fill Text   ${Bank_Account_num}         123123123
    ${Save_Button} =        Get Element             xpath=${Save_Button_XPath}
    Click   ${Save_Button}
    ${Length2} =                   Get Element Count     xpath=${Accounts_List}
    Should be equal             ${Length+1}   ${Length2}     

Should be able to delete the new bank account
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${Sign_in} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click       ${Sign_in}
    ${Bank_Accounts_Button} =   Get Element     xpath=${Bank_Accounts_XPath}
    Click       ${Bank_Accounts_Button}
    ${Length} =                   Get Element Count     xpath=${Accounts_List}
    ${Delete_Recent} =      Get Element                 xpath=//*[@id="root"]/div/main/div[2]/div/div/div/ul/li[${Length}]/div/div[2]/button
    Click   ${Delete_Recent}
    ${Deleted} =            Get Element                 xpath=//*[@id="root"]/div/main/div[2]/div/div/div/ul/li[${Length}]/div/div/p
    Get Text            ${Deleted}          equals          TDAmeritrade (Deleted)
