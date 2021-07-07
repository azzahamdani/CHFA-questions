#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#


set -ev

cd networkFiles

# generate the genesis block
configtxgen -profile EtcdRaftGenesis -channelID system-channel -outputBlock ./config/genesis.block

# bring up the network
./start.sh

     
    
       
