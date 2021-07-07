#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

set -ev

# Set env vars
export CHANNEL_NAME=mychannel

docker-compose -f docker-compose.yml down

docker-compose -f docker-compose.yml up -d orderer.example.com orderer2.example.com orderer3.example.com \
orderer4.example.com orderer5.example.com peer0.org1.example.com cli


