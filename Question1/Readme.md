
# Prerequisite
Before starting the question please make sure that your environment is setup correctly and the environment of the question is Up and Running
To bring Up the network 

```sh
# navigate to the question 
cd Question1/networkFiles/
# bring up the environment
./start.sh
```
After finishing with the question make sure to bring the network down 
```sh
# bring down the network
./teardown.sh
```

# Question 1: Install a chaincode 

### Data Summary
| Network Entity | Value |
| ------ | ------ |
| Peer Address | peer0.org1.example.com:7051 |
| Orderer Address | orderer.example.com:7050 |
| Channel Name | mychannel |
| Chaincode Name | abcc |
| Chaincode Path | /opt/gopath/src/github.com/chaincode/abstore/javascript |

### Question
1. Install nodejs chaincode at `/opt/gopath/src/github.com/chaincode/abstore` with name `abcc`, sequence number `1` and version `1.0` in the running network having one organisation Org1 with one peer peer0.org1.example.com. Use `abcc_0.1` as tag to follow the best practice 

2. Initiate the deployed chaincode with agrs `["init","a","888","b","200"]` 

### Note 1
> All the operations should be performed from within the CLI: to access the CLI use the command 
> docker exec -it cli bash

### Note 2
> This Network is TLS enabled, you can find the TLS certificate for RootCA for the Orderer saved 
> in environment variable ***$ORDERER_TLS_CA***
