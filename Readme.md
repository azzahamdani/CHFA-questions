# Before you begin 
#### prerequisite 
* **Linux OS** 18.04 LTE or above 
* **Docker** : install [docker](https://docs.docker.com/engine/install/ubuntu/) 
* **Docker-compose** : install [docker compose](https://docs.docker.com/compose/install/) 
* **Fabric-Binaries** 

To get fabric-binaries you can use this link*
shell script from the documentation that contains fabric-samples and farbric-binaries
```sh
curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.2.1 1.5.1
sudo cp ./fabric-samples/bin/* /usr/local/bin/
```

#### Note 
Dont delete fabric-samples folder as it contains our reference chaincode

# CHFA Questions 
* [Question 01: Install chaincode](./Question1/Readme.md)   
* [Question 02: Upgrade chaincode with Endorsement policy](./Question2/Readme.md) 
* [Question 04: Configure Ordering service (Raft)](./Question6/Readme.md) 
* [Question 05: Join a Channel](./Question5/Readme.md) 
* [Question 11: Create an Identity](./Question11/Readme.md)

