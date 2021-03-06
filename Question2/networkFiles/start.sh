#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

set -ev

# Set env vars
export CHANNEL_NAME=mychannel
export CC_NAME=mycc
export CC_VERSION=1.0

docker-compose -f docker-compose.yml down

docker-compose -f docker-compose.yml up -d orderer.example.com peer0.org1.example.com \
    peer0.org2.example.com cli 

# Wait for Hyperledger Fabric to start
# In case of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=15
sleep ${FABRIC_START_TIMEOUT}

# Create the application channel
ORDERER_TLS_CA=`docker exec cli  env | grep ORDERER_TLS_CA | cut -d'=' -f2`
docker exec cli peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f /etc/hyperledger/configtx/$CHANNEL_NAME.tx --tls --cafile $ORDERER_TLS_CA

# Join peer0.org1.example.com to the channel
docker exec cli peer channel join -b $CHANNEL_NAME.block

# Join peer0.org2.example.com to the channel
docker exec -e CORE_PEER_LOCALMSPID=Org2MSP -e CORE_PEER_ADDRESS=peer0.org2.example.com:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp \
    cli peer channel fetch oldest $CHANNEL_NAME.block -c $CHANNEL_NAME --orderer orderer.example.com:7050 --tls --cafile $ORDERER_TLS_CA

docker exec -e CORE_PEER_LOCALMSPID=Org2MSP -e CORE_PEER_ADDRESS=peer0.org2.example.com:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp \
    cli peer channel join -b $CHANNEL_NAME.block

# Anchor peer - peer1.org1.example.com
docker exec -e CORE_PEER_ADDRESS=peer1.org1.example.com:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt \
    cli peer channel update -o orderer.example.com:7050 --tls --cafile $ORDERER_TLS_CA -c $CHANNEL_NAME -f /etc/hyperledger/configtx/Org1MSPanchors.tx 
    
# Anchor peer - peer1.org2.example.com
docker exec -e CORE_PEER_LOCALMSPID=Org2MSP -e CORE_PEER_ADDRESS=peer1.org2.example.com:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp \
    cli peer channel update -o orderer.example.com:7050 --tls --cafile $ORDERER_TLS_CA -c $CHANNEL_NAME -f /etc/hyperledger/configtx/Org2MSPanchors.tx 

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
    --channelID ${CHANNEL_NAME} \
    --name ${CC_NAME} \
    --version ${CC_VERSION} \
    --package-id ${CC_PACKAGE_ID} \
    --sequence 1 \
    --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem


# Approve chaincode for Org2
docker exec -e CORE_PEER_LOCALMSPID=Org2MSP -e CORE_PEER_ADDRESS=peer0.org2.example.com:7051 \
    -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt \
    -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp \
    cli peer lifecycle chaincode approveformyorg \
    -o orderer.example.com:7050 \
    --channelID ${CHANNEL_NAME} \
    --name ${CC_NAME} \
    --version ${CC_VERSION} \
    --package-id ${CC_PACKAGE_ID} \
    --sequence 1 \
    --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# Check commit readiness 
docker exec cli peer lifecycle chaincode checkcommitreadiness \
    --channelID ${CHANNEL_NAME} \
    --name ${CC_NAME} \
    --version ${CC_VERSION} \
    --sequence 1 \
    --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
    --output json

# Commit chaincode
docker exec cli peer lifecycle chaincode commit \
    -o orderer.example.com:7050 \
    --channelID ${CHANNEL_NAME} \
    --name ${CC_NAME} --version ${CC_VERSION} --sequence 1 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
    --peerAddresses peer0.org1.example.com:7051 \
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
    --peerAddresses peer0.org2.example.com:7051 \
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt 

# Query the committed chaincode 
docker exec cli peer lifecycle chaincode querycommitted \
    --channelID ${CHANNEL_NAME} \
    --name ${CC_NAME} \
    --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

rm -rf log.txt


