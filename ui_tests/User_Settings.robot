*** Settings ***
Library     Browser


***Variables***
${User_Account_XPath}   //*[@id="root"]/div/div/div/div[2]/div[3]/ul/div/a[2]
${Save_Button_XPath}    //*[@id="root"]/div/main/div[2]/div/div/div/div/div[2]/form/div[5]/div/button
${Home_Button_XPath}    //*[@id="root"]/div/div/div/div[2]/div[3]/ul/div/a[1]
&{Login_Info}       username=Katharina_Bernier    password=s3cret
&{USER_SETTINGS_INFO}       fName=phil          lName=Johns         email=Norene39@yahoo.com        phone=625-316-9882

*** Test Cases ***
should redirect to the user settings page after selecting my account
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${element} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click       ${element}
    ${element} =    Get Element    xpath=${User_Account_XPath}
    Click       ${element}
    Get Url         equals          http://localhost:3000/user/settings

User Settings page should have a spot to update First Name
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${element} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click       ${element}
    ${element} =    Get Element     xpath=${User_Account_XPath}
    Click       ${element} 
    ${element} =    Get Element     xpath=//*[@id="user-settings-firstName-input"]
    Get Text        ${element}      equals          ${USER_SETTINGS_INFO}[fName]
 
 User Settings page should have a spot to update Last Name
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${element} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click       ${element}
    ${element} =    Get Element     xpath=${User_Account_XPath}
    Click       ${element} 
    ${element} =    Get Element     xpath=//*[@id="user-settings-lastName-input"]
    Get Text     ${element}     equals             ${USER_SETTINGS_INFO}[lName]

User Settings page should have a spot to update email
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${element} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click       ${element}
    ${element} =    Get Element     xpath=${User_Account_XPath}
    Click       ${element} 
    ${element} =    Get Element     xpath=//*[@id="user-settings-email-input"]
    Get Text     ${element}     equals             ${USER_SETTINGS_INFO}[email]

User Settings page should have a spot to update phone number
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${element} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click       ${element}
    ${element} =    Get Element     xpath=${User_Account_XPath}
    Click       ${element} 
    ${element} =    Get Element     xpath=//*[@id="user-settings-phoneNumber-input"]
    Get Text     ${element}     equals             ${USER_SETTINGS_INFO}[phone]

User settings should have a save button available
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${element} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click       ${element}
    ${element} =    Get Element     xpath=${User_Account_XPath}
    Click       ${element} 
    ${element} =    Get Element     xpath=${Save_Button_XPath}

User should be able to update their First Name in user settings and save it
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${element} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click       ${element}
    ${element2} =    Get Element     xpath=${User_Account_XPath}
    Click       ${element2} 
    ${first_name} =    Get Element     xpath=//*[@id="user-settings-firstName-input"]
    Get Text        ${first_name}      equals          ${USER_SETTINGS_INFO}[fName]
    Fill Text       ${first_name}      NewName
    ${save_button} =    Get Element     xpath=${Save_Button_XPath}
    Click   ${save_button}
    ${element} =    Get Element     xpath=${Home_Button_XPath}
    Click   ${element}
    Click   ${element2}
    Get Text        ${first_name}       equals      NewName
    Fill Text       ${first_name}       ${USER_SETTINGS_INFO}[fName]
    Click   ${save_button}

User should be able to update their Last Name in user settings and save it
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${element} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click       ${element}
    ${element2} =    Get Element     xpath=${User_Account_XPath}
    Click       ${element2} 
    ${last_name} =    Get Element     xpath=//*[@id="user-settings-lastName-input"]
    Get Text        ${last_name}      equals          ${USER_SETTINGS_INFO}[lName]
    Fill Text       ${last_name}      NewName
    ${save_button} =    Get Element     xpath=${Save_Button_XPath}
    Click   ${save_button}
    ${element} =    Get Element     xpath=${Home_Button_XPath}
    Click   ${element}
    Click   ${element2}
    Get Text        ${last_name}       equals      NewName
    Fill Text       ${last_name}       ${USER_SETTINGS_INFO}[lName]
    Click   ${save_button}

User should be able to update their Email in user settings and save it
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${element} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click       ${element}
    ${element2} =    Get Element     xpath=${User_Account_XPath}
    Click       ${element2} 
    ${email} =    Get Element     xpath=//*[@id="user-settings-email-input"]
    Get Text        ${email}      equals          ${USER_SETTINGS_INFO}[email]
    Fill Text       ${email}      differenetEmail@gmail.com
    ${save_button} =    Get Element     xpath=${Save_Button_XPath}
    Click   ${save_button}
    ${element} =    Get Element     xpath=${Home_Button_XPath}
    Click   ${element}
    Click   ${element2}
    Get Text        ${email}       equals      differenetEmail@gmail.com
    Fill Text       ${email}       ${USER_SETTINGS_INFO}[email]
    Click   ${save_button}
    
User should be able to update their phone number in user settings and save it
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${element} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click       ${element}
    ${element2} =    Get Element     xpath=${User_Account_XPath}
    Click       ${element2} 
    ${phone} =    Get Element     xpath=//*[@id="user-settings-phoneNumber-input"]
    Get Text        ${phone}      equals          ${USER_SETTINGS_INFO}[phone]
    Fill Text       ${phone}      123-456-7890
    ${save_button} =    Get Element     xpath=${Save_Button_XPath}
    Click   ${save_button}
    ${element} =    Get Element     xpath=${Home_Button_XPath}
    Click   ${element}
    Click   ${element2}
    Get Text        ${phone}       equals      123-456-7890
    Fill Text       ${phone}       ${USER_SETTINGS_INFO}[phone]
    Click   ${save_button}

User should be able to update all of their settings at once in user settings and save it
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    ${Login_Info}[username]
    Fill Text    id=password    ${Login_Info}[password]
    ${element} =    Get Element     xpath=//button/span[text()="Sign In"]
    Click       ${element}
    ${element2} =    Get Element     xpath=${User_Account_XPath}
    Click       ${element2} 
    ${last_name} =    Get Element     xpath=//*[@id="user-settings-lastName-input"]
    Get Text        ${last_name}      equals          ${USER_SETTINGS_INFO}[lName]
    Fill Text       ${last_name}      NewLastName
    ${first_name} =    Get Element     xpath=//*[@id="user-settings-firstName-input"]
    Get Text        ${first_name}      equals          ${USER_SETTINGS_INFO}[fName]
    Fill Text       ${first_name}      NewFirstName
    ${email} =    Get Element     xpath=//*[@id="user-settings-email-input"]
    Get Text        ${email}      equals          ${USER_SETTINGS_INFO}[email]
    Fill Text       ${email}      newEmail@gmail.com
    ${phone} =    Get Element     xpath=//*[@id="user-settings-phoneNumber-input"]
    Get Text        ${phone}      equals          ${USER_SETTINGS_INFO}[phone]
    Fill Text       ${phone}      123-456-7890
    ${save_button} =    Get Element     xpath=${Save_Button_XPath}
    Click   ${save_button}
    ${element} =    Get Element     xpath=${Home_Button_XPath}
    Click   ${element}
    Click   ${element2}
    Get Text        ${last_name}        equals      NewLastName
    Fill Text       ${last_name}        ${USER_SETTINGS_INFO}[lName]
    Get Text        ${first_name}       equals      NewFirstName
    Fill Text       ${first_name}       ${USER_SETTINGS_INFO}[fName]
    Get Text        ${email}            equals      newEmail@gmail.com
    Fill Text       ${email}            ${USER_SETTINGS_INFO}[email]
    Get Text        ${phone}            equals      123-456-7890
    Fill Text       ${phone}            ${USER_SETTINGS_INFO}[phone]
    Click   ${save_button}