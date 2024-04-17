*** Settings ***
Library    RequestsLibrary
Library    ../lib/CustomLib.py
Library    Collections

*** Variables ***
${api}     http://localhost:3001  # base URL of the API

*** Test Cases ***
gets the list of bank transfers for a user
    POST    ${api}/testData/seed
    Create Session     alias    ${api}/login
    POST On Session    alias    ${api}/login     params=username=Katharina_Bernier&password=s3cret
    ${resp}=    GET On Session      alias   ${api}/bankTransfers    expected_status=200
    ${data_results}     Set Variable    ${resp.json()}[transfers]
    ${data_length}=    get length       ${data_results}
    Should Be True    ${data_length} > 0
    Should Be Equal    ${resp.json()}[transfers][0][userId]    t45AiwidW
