#!/bin/bash
#
# Nico Krause (nico@le-space.de)
#
# This bash script gets called by the doichain-wallet when a new block arrives.
# As soon the difficulty of a block is higher then 1000 we change 'consensus.nPowTargetTimespan' to 14 * 24 * 60 * 60 
# stop the node and do a make, make install and 
# start the node again with parameter -walletnotify=/home/doichain/data/.namecoin/normalise-difficulty.sh
diff=0
goal=1000
diffHighEnough=0
 while [  $diffHighEnough == 0 ]; do
     diff=$(docker exec testnet-alice namecoin-cli getblockchaininfo |jq '.difficulty' | sed 'y/e/E/')
     diffHighEnough=$(echo $diff'>'$goal | bc -l)
     echo "current difficulty is"$diff 
     sleep 5
 done

 echo "alice: changing nPowTargetTimeSpan and compiling this namecoind again" 
 docker exec -w /home/doichain/namecoin-core testnet-alice sudo sed -i.bak -e "s/consensus.nPowTargetTimespan[[:space:]]=[[:space:]]0.4/consensus.nPowTargetTimespan = 15/g" src/chainparams.cpp
 docker exec -w /home/doichain/namecoin-core testnet-alice sudo make
 docker exec -w /home/doichain/namecoin-core testnet-alice namecoin-cli stop
 docker exec -w /home/doichain/namecoin-core testnet-alice sudo make install
 docker exec testnet-alice namecoind -testnet

 echo "bob: changing nPowTargetTimeSpan and compiling this namecoind again" 
 docker exec -w /home/doichain/namecoin-core testnet-bob sudo sed -i.bak -e "s/consensus.nPowTargetTimespan[[:space:]]=[[:space:]]0.4/consensus.nPowTargetTimespan = 15/g" src/chainparams.cpp
 docker exec -w /home/doichain/namecoin-core testnet-bob sudo make
 docker exec -w /home/doichain/namecoin-core testnet-bob namecoin-cli stop
 docker exec -w /home/doichain/namecoin-core testnet-bob sudo make install
echo "Now normalise nPowTargetTimespani again" 
 docker exec testnet-bob namecoind -testnet

