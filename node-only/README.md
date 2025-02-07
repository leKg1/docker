# doichain/node-only docker image 
### a Doichain node (without integrated Doichain dApp)

### Installation (you can skip step 1 and 2 if you want to use the image from docker hub!)
1. clone this repository ```git clone https://github.com/Doichain/docker.git doichain-docker```
2. build docker image 
```shell
cd doichain-docker/node-only
docker build --no-cache -t doichain/node-only --build-arg DOICHAIN_VER=dc0.20.1.9 .
```
3. Run docker image 
   
   Parameters:
    * *-e RPC_PASSWORD=<your-rpc-password>* (optional) - if not given it will be generated by the start script - see ~/.doichain/doichain.conf 
    * *-e TESTNET=true*  in case you run Testnet, if you run Mainnet, please remove
    * *-e DAPP_URL=http://localhost:4010* (optional) the URL of you local dApp (mainnet default: http://localhost:3000 testnet no default but use: http://localhost:4010)
   
```shell
#mainnet example
docker run -it -e RPC_PASSWORD=<my-rpc-password> --name doichain-testnet doichain/node-only

#testnet example
docker run -it -e TESTNET=true -p DAPP_URL=http://localhost:4010 -p 18339:18339 -e RPC_PASSWORD=<my-rpc-password> --name doichain-testnet doichain/node-only
```
4. Connect into docker container and check if node connects to testnet
```shell
docker exec -it doichain-testnet doichain-cli -getinfo
```
5. Please ALWAYS backup your privatKeys! via 
```shell
docker exec -it doichain-testnet doichain-cli getnewaddress
docker exec -it doichain-testnet doichain-cli dumpprivkey <address>
```