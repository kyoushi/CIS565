*** Settings ***
Library    RequestsLibrary
Library    ../lib/CustomLib.py
Library    Collections

*** Variables ***
${api}     http://localhost:3001  # base URL of the API

*** Test Cases ***
gets a list of transactions for user
    POST    ${api}/testData/seed
    Create Session     alias    ${api}/login
    POST On Session    alias    ${api}/login     params=username=Katharina_Bernier&password=s3cret

    ${resp}=    GET On Session      alias   ${api}/transactions    expected_status=200
    ${data_results}     Set Variable    ${resp.json()}[results]
    ${data_length}=    get length       ${data_results}
    Should Be True    ${data_length} > 0
    ${first_transaction}    Set Variable    ${resp.json()}[results][0]

    Log    Value of first_transaction["senderName"]: ${first_transaction["senderName"]}  # Debug print statement
    Log    Value of first_transaction["receiverName"]: ${first_transaction["receiverName"]}  # Debug print statement

    Run Keyword If    not "${first_transaction['senderName']}"    Fail    Sender not found in the first transaction
    Run Keyword If    not "${first_transaction['receiverName']}"    Fail    Receiver not found in the first transaction


gets a list of pending request transactions for user
    
    POST    ${api}/testData/seed
    Create Session     alias    ${api}/login
    POST On Session    alias    ${api}/login     params=username=Katharina_Bernier&password=s3cret

    ${query_params}    Create Dictionary    requestStatus=pending

    ${resp}=    GET On Session      alias   ${api}/transactions     params=${query_params}    

    Should Be Equal As Strings    ${resp.status_code}    200


Creates a new payment

    POST    ${api}/testData/seed
    Create Session     alias    ${api}/login
    POST On Session    alias    ${api}/login     params=username=Katharina_Bernier&password=s3cret
    ${body}=    Evaluate    json.loads($json_string)    json

    ${response}=    Post On Session         alias   ${api}/transactions        json=${body}
    Should Be Equal As Strings    ${response.status_code}    200

    ${transaction_id}    Set Variable    ${response.json()["transaction"]["id"]}
    Should Be True    "${transaction_id}" != ""    # Ensure transaction ID is not empty

    ${status}    Set Variable    ${response.json()["transaction"]["status"]}
    Should Be Equal As Strings    ${status}    complete

    ${request_status}    Set Variable    ${response.json()["transaction"]["requestStatus"]}
    Should Be Equal As Strings    ${request_status}    None


*** Variables ***
${json_string}    {"source": "RskoB7r4Bic", "receiverId": "t45AiwidW", "description": "Payment: t45AiwidW to qywYp6hS0U", "amount": 47212, "privacyLevel": "public"}


    