#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#


set -ev

# Set env vars
export CHANNEL_NAME=boat

# Create the application channel
ORDERER_TLS_CA=`docker exec cli  env | grep ORDERER_TLS_CA | cut -d'=' -f2`
docker exec cli peer channel fetch 0 $CHANNEL_NAME.block -o orderer.example.com:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_TLS_CA  

# Join peer0.org1.example.com to the channel
docker exec cli peer channel join -b $CHANNEL_NAME.block
     
    
       
