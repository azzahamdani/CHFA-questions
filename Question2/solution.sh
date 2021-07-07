#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

CC_NAME=mycc
CHANNEL_NAME=mychannel
CC_VERSION=v3.0.2
ORDERER_TLS_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

set -ev

# Package the chaincode 
docker exec cli peer lifecycle chaincode package ${CC_NAME}.tar.gz --path /opt/gopath/src/github.com/chaincode/abstore/javascript/ --lang node --label ${CC_NAME}_${CC_VERSION}

# Install chaincode in peer0.org1.example.com
docker exec cli peer lifecycle chaincode install ${CC_NAME}.tar.gz

# Install chaincode in peer0.org2.example.com
docker exec -e CORE_PEER_LOCALMSPID=Org2MSP -e CORE_PEER_ADDRESS=peer0.org2.example.com:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp \
    cli peer lifecycle chaincode install ${CC_NAME}.tar.gz

# Query the installed chaincode to save package ID
docker exec cli peer lifecycle chaincode queryinstalled > log.txt

# Save the package ID
CC_PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)

# Approve chaincode for Org1
docker exec cli peer lifecycle chaincode approveformyorg \
     -o orderer.example.com:7050 \
     --channelID mychannel \
     --name mycc \
     --version v3.0.2 \
     --package-id $CC_PACKAGE_ID \
     --sequence 2 \
     --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
     --init-required \
     --signature-policy "AND('Org1.peer', 'Org2.peer')"

# Approve chaincode for Org2
docker exec -e CORE_PEER_LOCALMSPID=Org2MSP -e CORE_PEER_ADDRESS=peer0.org2.example.com:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp \
    cli peer lifecycle chaincode approveformyorg \
    -o orderer.example.com:7050 \
     --channelID mychannel \
     --name mycc \
     --version v3.0.2 \
     --package-id $CC_PACKAGE_ID \
     --sequence 2 \
     --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
     --init-required \
     --signature-policy "AND('Org1.peer', 'Org2.peer')"



# Check commit readiness 
docker exec cli peer lifecycle chaincode checkcommitreadiness \
    --channelID ${CHANNEL_NAME} \
    --name ${CC_NAME} \
    --version ${CC_VERSION} \
    --sequence 2 \
    --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
    --signature-policy "AND('Org1.peer', 'Org2.peer')" \
    --init-required --output json

# # Commit chaincode
docker exec cli peer lifecycle chaincode commit \
    -o orderer.example.com:7050 \
    --channelID ${CHANNEL_NAME} \
    --name ${CC_NAME} --version ${CC_VERSION} --sequence 2 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
    --peerAddresses peer0.org1.example.com:7051 \
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
    --peerAddresses peer0.org2.example.com:7051 \
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
    --signature-policy "AND('Org1.peer', 'Org2.peer')" \
    --init-required

# Query the committed chaincode 
docker exec cli peer lifecycle chaincode querycommitted \
    --channelID ${CHANNEL_NAME} \
    --name ${CC_NAME} \
    --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# # Invoke the initialisation 
docker exec cli peer chaincode invoke \
    -o orderer.example.com:7050 \
    --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
    -C ${CHANNEL_NAME} \
    -n ${CC_NAME} \
    --peerAddresses peer0.org1.example.com:7051 \
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
    --peerAddresses peer0.org2.example.com:7051 \
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
    -c '{"Args":["init","a","888","b","200"]}' --isInit

rm -rf log.txt ab.txt

     
    
       
