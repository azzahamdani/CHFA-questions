#!/bin/bash
echo -e "Checking Objectives..."
OBJECTIVE_NUM=0
function printresult {
  ((OBJECTIVE_NUM+=1))
  echo -e "\n----- Checking Objective $OBJECTIVE_NUM -----"
  echo -e "----- $1"
  if [ $2 -eq 0 ]; then
      echo -e "      \033[0;32m[COMPLETE]\033[0m Congrats! This objective is complete!"
  else
      echo -e "      \033[0;31m[INCOMPLETE]\033[0m This objective is not yet completed!"
  fi
}



docker ps --format "table {{.Names}}" > orderer.txt

expected="NAMES
cli
peer0.org1.example.com
orderer.example.com
orderer3.example.com
orderer2.example.com
orderer5.example.com
orderer4.example.com"
actual=$(cat orderer.txt 2>/dev/null)
[[ "$actual" = "$expected" ]]
printresult "Install the chaincode in peer0.org1.example.com." $?




# rm querychaincode.txt ab.txt
