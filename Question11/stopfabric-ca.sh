# Stop the service 
sudo systemctl stop fabric-ca.service

# Disable the service 
sudo systemctl disable fabric-ca.service

# Remove the service from /etc/systemd/system
sudo rm /etc/systemd/system/fabric-ca.service

# Reload systemctl
sudo systemctl daemon-reload
sudo systemctl reset-failed

# Delete FABRIC_CA_SERVER_HOME
sudo rm -rf /etc/hyperledger/fabric-ca-server