#!/bin/bash

# create the service Config file 
cat > fabric-ca.service << EOF
# Service definition for Hyperledger fabric-ca server
[Unit]
Description=hyperledger fabric-ca server - Certificate Authority for hyperledger fabric
Documentation=https://hyperledger-fabric-ca.readthedocs.io/
Wants=network-online.target
After=network-online.target
[Service]
Type=simple
Restart=on-failure
Environment=FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
Environment=FABRIC_CA_SERVER_HOME=/etc/hyperledger/fabric-ca-server
Environment=CA_CFG_PATH=/etc/hyperledger/fabric-ca
ExecStart=/usr/local/bin/fabric-ca-server start -b admin:adminpw
[Install]
WantedBy=multi-user.target
EOF

# Move the service Config under /etc/systemd.system 
sudo mv fabric-ca.service /etc/systemd/system/

# Enable the service
sudo systemctl enable fabric-ca.service

# Enable the service
sudo systemctl start fabric-ca.service

# Check the status 
systemctl status fabric-ca.service