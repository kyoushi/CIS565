*** Settings ***
Library    Browser

*** Test Cases ***
should redirect unauthenticated user to signin page
    Open Browser
    New Page    http://localhost:3000/personal
    Get Url    equals    http://localhost:3000/signin