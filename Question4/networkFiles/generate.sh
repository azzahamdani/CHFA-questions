#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# Set env vars
export FABRIC_CFG_PATH=${PWD}
export CHANNEL_NAME=mychannel

# Remove previous crypto material and config transactions
mkdir -p config
rm -fr config/*
rm -fr crypto-config/*

# Generate crypto material
cryptogen generate --config=./crypto-config.yaml
if [ "$?" -ne 0 ]; then
  echo "Failed to generate crypto material..."
  exit 1
fi


