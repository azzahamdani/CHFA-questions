# Prerequisite
Before starting the question please make sure that your environment is setup correctly and the environment of the question is Up and Running

To start fabric-ca
```sh
./startfabric-ca.sh
```

# Question 11: Create an Identity

Hyperledger Fabric CA has been installed in node X. Create an identity with name ***userABC*** of type user, affiliation as ***org1.department1*** and secret as ***passwd***.

The ***userABC*** identity should have the following privileges 
A. Can register new identities of type client 
B. Can revoke the identities.

Return to the base node upon completion.

### Note 1
You can enroll the fabric admin user with name admin and password adminpw.

### Note 2
You shouldn't update the default path of the Fabric CA Client home directory.