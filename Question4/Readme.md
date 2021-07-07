
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
| Orderer Address | orderer.example.com:7050 |


### Question
1. Update /networkFiles/configtx.yaml to suppport a Policy where all 


### Note 1
> All the operations should be performed from within the CLI: to access the CLI use the command 
> `docker exec -it cli bash`

### Note 2
> This Network is TLS enabled, you can find the TLS certificate for RootCA for the Orderer saved 
> in environment variable ***$ORDERER_TLS_CA***
