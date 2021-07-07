
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

# Question 1: Install a chaincode 

### Data Summary
| Network Entity | Value |
| ------ | ------ |
| Peer Address | peer0.org1.example.com:7051 |
| Peer Address | peer1.org1.example.com:7051 |
| Orderer Address | orderer.example.com:7050 |
| Channel Name | boat |


### Question
1. Join the `peer1.org1.example.com` to the already existing channel `boat` in the running network componed of one organization Org1 with two peers `peer0.org1.example.com` and `peer1.org1.example.com`. The channel is already created in `peer1.org1.example.com`.


### Note 1
> All the operations should be performed from within the CLI: to access the CLI use the command 
> `docker exec -it cli bash`

### Note 2
> This Network is TLS enabled, you can find the TLS certificate for RootCA for the Orderer saved 
> in environment variable ***$ORDERER_TLS_CA***
