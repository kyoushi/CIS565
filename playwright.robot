*** Settings ***
Library   Browser  jsextension=${CURDIR}/lib/NativePlaywright.js

*** Test Cases ***
Example Test with JS NativePlaywright
   Open Browser
   my Go To Keyword   http://localhost:3000/signin
   fill Text Element    xpath=//input[@id="username"]    gerardo
   fill Text Element    id=password    password1
   click Element    xpath=//button/span[text()="Sign In"]
   Wait For Elements State    css=[data-test="signin-error"]    visible    timeout=5 s
   ${text}=    get Text Element   css=[data-test="signin-error"]
   Should Be Equal  ${text}    Username or password is invalid