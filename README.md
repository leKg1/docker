# doichain/docker
## a docker image for the Doichain environment http://www.doichain.org

### How to use this docker container?
1. if you want to register one or more "double-opt-in" for your customer email adresses install a SEND_DAPP
2. if you want to protect your email server from unwanted spam install CONFIRM_DAPP and VERIFY_APP (experimental)

### Build from doichain/docker GitHub repository 
1. Checkout this repository with: ``git clone https://github.com/Doichain/docker.git docker-doichain``
2. Build docker container with ``cd docker-doichain; docker build -t mydocker/doichain:latest .``

### Install from docker hub https://hub.docker.com/r/doichain/dapp/
replace ``mydocker/doichain:latest``with ``doichain/dapp:latest``

### Installation Send - dApp 
1. Install ``docker run -it --rm -e DAPP_SEND='true' -p 3000:3000  mydocker/doichain:latest``
2. Get auth token with: ``curl -H "Content-Type: application/json" -X POST -d '{"username":"admin","password":"password"}' http://localhost:3000/api/v1/login``

    Output should be something like:

    ```
    {
      "status": "success",
      "data": {
        "authToken": "Y1z8vzJMo1qqLjr1pxZV8m0vKESSUxmRvbEBLAe8FV3",
        "userId": "a7Rzs7KdNmGwj64Eq"
    }
    ```

3. Give your Send - dAPP some funding: (during alpha test, please send your doichain address to funding@doichain.org)
4. DOI-Request  
Take the **authToken** and **userId** from above and paste it into the appropriate header fields below. 
```
curl -X POST -H 'X-User-Id: a7Rzs7KdNmGwj64Eq' -H 'X-Auth-Token: Y1z8vzJMo1qqLjr1pxZV8m0vKESSUxmRvbEBLAe8FV3' -i 'http://SEND_DAPP_HOST:3000/api/v1/opt-in?recipient_mail=<your-customer-email@example.com>&sender_mail=info@doichain.org'
```

    Output should be: 
    ```
      {
      "status": "success",
      "data": {
        "message": "Opt-In added. ID: SyXPehQz6utWnacRa"
      }
    ```


### Installation Confirmation - dApp
1. Install ``docker run --name=doichain-<your-host> --hostname=doichain-<your-host> -it --rm -e DAPP_CONFIRM='true' -e DAPP_VERIFY='true' -e DAPP_SEND='true' -e RPC_USER='admin' -e RPC_PASSWORD='ekb2018!' -e RPC_HOST=localhost -e DAPP_HOST=<dAppHostFromTheInternet:Port> -e DAPP_SMTP_HOST=<smtp-host> -e DAPP_SMTP_USER=<smtp-username> -e DAPP_SMTP_PASS=<smtp-password> -e DAPP_SMTP_PORT=25 -p 3007:3000 -p 8338:8338-v doichain.org:/home/doichain/data  inspiraluna/doichain:0.0.2``

2. Update the DNS of your mail domain(s) :
   1. Connect to your running docker container via ``docker ps`` and ``docker attach <your-cointainer>`` 
   2. list your accounts with ``namecoin-cli listaccounts``
   3. get the account address of your account ``namecoin-cli getaccountaddress ""`` or use:``namecoin-cli getaddressesbyaccount ""``
   4. get the ``pubkey`` from ``namecoin-cli validateaddress <your-address>``
   5. add a **TXT** field ``doichain-opt-in-provider:<your-email-domain e.g. doichain.org>``
   6. add a **TXT** field ``doichain-opt-in-key:<your pubkey from above> ``
   7. exit your docker cointainer 
   8. start docker container again with an additional environment variable ``-e CONFIRM_ADDRESS=<your-address>`` (or modify `/home/doichain/data/dapp/settings.json ``) which is the address of you found under 2.3 
3. check if your blockchain receive blocks with: ``namecoin-cli getblockcount``
4. check your balance with ``namecoin-cli getbalance`` (send some coins with ``namecoin-cli sendtoaddress ``)

### Installation Verify - dApp
2. docker run --name=doichain-<your-host> --hostname=doichain-<your-host> -it --rm -e DAPP_CONFIRM='true' -e DAPP_VERIFY='true' -e DAPP_SEND='true' -e RPC_USER='admin' -e RPC_PASSWORD='ekb2018!' -e RPC_HOST=localhost -e DAPP_HOST=<dAppHostFromTheInternet:Port> -e DAPP_SMTP_HOST=<smtp-host> -e DAPP_SMTP_USER=<smtp-username> -e DAPP_SMTP_PASS=<smtp-password> -e DAPP_SMTP_PORT=25 -p 3007:3000 -p 8338:8338-v doichain.org:/home/doichain/data  inspiraluna/doichain:0.0.2