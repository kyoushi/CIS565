*** Settings ***
Library    Browser

*** Test Cases ***
should redirect unauthenticated user to signin page
    Open Browser
    New Page    http://localhost:3000/personal
    Get Url    equals    http://localhost:3000/signin

should redirect to the home page after login
    Open Browser
    New Page    http://localhost:3000/signin
    Fill Text    id=username    Katharina_Bernier
    Fill Text    id=password    s3cret
    ${element} =    Get Element    xpath=//button/span[text()="Sign In"]
    Click    ${element}
    Get Url    equals    http://localhost:3000/
