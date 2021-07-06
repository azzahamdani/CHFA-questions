#!/bin/bash
echo -e "Checking Objectives..."
OBJECTIVE_NUM=0
function printresult {
  ((OBJECTIVE_NUM+=1))
  echo -e "\n----- Checking Objective $OBJECTIVE_NUM -----"
  echo -e "----- $1"
  if [ $2 -eq 0 ]; then
      echo -e "      \033[0;32m[COMPLETE]\033[0m Congrats! This objective is complete!"
  else
      echo -e "      \033[0;31m[INCOMPLETE]\033[0m This objective is not yet completed!"
  fi
}

CC_NAME=abcc
CHANNEL_NAME=mychannel
CC_VERSION=1.0

docker exec cli peer lifecycle chaincode querycommitted \
    --channelID ${CHANNEL_NAME} \
    --name ${CC_NAME} \
    --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
    > querychaincode.txt

expected="Committed chaincode definition for chaincode 'abcc' on channel 'mychannel':
Version: 1.0, Sequence: 1, Endorsement Plugin: escc, Validation Plugin: vscc, Approvals: [Org1MSP: true]"
actual=$(cat querychaincode.txt 2>/dev/null)
[[ "$actual" = "$expected" ]]
printresult "Install the chaincode in peer0.org1.example.com." $?


docker exec cli peer chaincode query \
    -C ${CHANNEL_NAME} \
    -n ${CC_NAME} \
    -c '{"Args":["query", "a"]}' \
    >> ab.txt

docker exec cli peer chaincode query \
    -C ${CHANNEL_NAME} \
    -n ${CC_NAME} \
    -c '{"Args":["query", "b"]}' \
    >> ab.txt

expected=$'888\n200'
actual=$(cat ab.txt 2>/dev/null)
[[ "$actual" = "$expected" ]]
printresult "Initialize chaincode with a=888 and b=200." $?

rm querychaincode.txt ab.txt
