# Prerequisite
Before starting the question please make sure that your environment is setup correctly and the environment of the question is Up and Running
To bring Up the network 

```sh
./prerequisite.sh
```
This exercise is meant to be done manually 
To verify your work run the script 
```sh
./verifymyresult.sh
```

# Question 2: Upgrade Chaincode with Endorsement Policy 

### Data Summary
| Network Entity | Value |
| ------ | ------ |
| Peer Address | peer0.org1.example.com:7051 |
| Peer Address | peer0.org2.example.com:7051 |
| Orderer Address | orderer.example.com:7050 |
| Channel Name | mychannel |
| Chaincode Name | mycc |
| Chaincode Path | /opt/gopath/src/github.com/chaincode/abstore/javascript |

### Question
1. Upgrade the already existant nodejs chaincode at `/opt/gopath/src/github.com/chaincode/abstore/javascript` with name `mycc`, sequence number `2` and version `v3.0.2` in the running network having two organisation Org1 and Org2 each with one peer peer0.org1.example.com and peer0.org2.example.com. Use best practice tagging and an endorsement policy that requires one peer for each organization to endorse.

2. Initiate the updated chaincode with agrs `["init","a","888","b","200"]` 

### Note 1
> All the operations should be performed from within the CLI: to access the CLI use the command 
> `docker exec -it cli bash`

### Note 2
> This Network is TLS enabled, you can find the TLS certificate for RootCA for the Orderer saved 
> in environment variable ***$ORDERER_TLS_CA***

## Note 3
> To switch Identities between Org1 and Org2 you can use the following scripts 
> `source /etc/hyperledger/scripts/set-org1.sh` 
> `source /etc/hyperledger/scripts/set-org2.sh` 

