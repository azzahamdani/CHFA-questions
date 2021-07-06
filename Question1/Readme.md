
# Prerequisite
Before starting the question please make sure that your environment is setup correctly and the environment of the question is Up and Running
To bring Up the network 

```sh
# navigate to the question 
cd Question1/networkFiles/
# bring up the environment
./start.sh
```
After finishing with the question make sure to bring the network down 
```sh
# bring down the network
./teardown.sh
```

# Question 1: Install a chaincode 

### Data Summary
| Network Entity | Value |
| ------ | ------ |
| Peer Address | peer0.org1.example.com:7051 |
| Orderer Address | orderer.example.com:7050 |
| Channel Name | mychannel |
| Chaincode Name | abcc |
| Chaincode Path | /opt/gopath/src/github.com/chaincode/abstore/javascript |

### Question
1. Install nodejs chaincode at `/opt/gopath/src/github.com/chaincode/abstore` with name `abcc`, sequence number `1` and version `1.0` in the running network having one organisation Org1 with one peer peer0.org1.example.com. Use `abcc_0.1` as tag to follow the best practice 

2. Initiate the deployed chaincode with agrs `["init","a","888","b","200"]` 

### Note 1
> All the operations should be performed from within the CLI: to access the CLI use the command 
> docker exec -it cli bash

### Note 2
> This Network is TLS enabled, you can find the TLS certificate for RootCA for the Orderer saved 
> in environment variable ***$ORDERER_TLS_CA***


=============================================================

peer lifecycle chaincode package abcc.tar.gz --path /opt/gopath/src/github.com/chaincode/abstore/javascript/ --lang node --label abcc_1.0

peer lifecycle chaincode install abcc.tar.gz

peer lifecycle chaincode queryinstalled

export CC_PACKAGE_ID=abcc_1.0:f319cf0b53e11e857a0a437a1389b8e3b0c0faa62d22b6f990108f596b0784ee

peer lifecycle chaincode approveformyorg -o orderer.example.com:7050 --channelID mychannel --name abcc --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile $ORDERER_TLS_CA --init-required

peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name abcc --version 1.0 --sequence 1 --tls --cafile $ORDERER_TLS_CA --init-required --output json

peer lifecycle chaincode commit -o orderer.example.com:7050 --channelID mychannel --name abcc --version 1.0 --sequence 1 --tls --cafile $ORDERER_TLS_CA --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE --init-required

peer lifecycle chaincode querycommitted --channelID mychannel --name abcc --cafile $ORDERER_TLS_CA 

peer chaincode invoke -o orderer.example.com:7050 --tls --cafile $ORDERER_TLS_CA -C mychannel -n abcc --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles ${PWD}/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt -c '{"Args":["init","a","888","b","200"]}' --isInit