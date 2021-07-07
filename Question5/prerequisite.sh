#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#


# navigate to the question 
cd networkFiles/
# clean the network
./teardown.sh
# generate the new artifacts
./generate.sh
# bring up the environment
./start.sh