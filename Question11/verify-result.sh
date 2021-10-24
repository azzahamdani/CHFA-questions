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

# tr -d '\n'
# TODO : works randomly

fabric-ca-client identity list --id userABC > identity.txt

expected="Name: userABC, Type: user, Affiliation: org1.department1, Max Enrollments: -1, Attributes: [{Name:hf.Type Value:user ECert:true} {Name:hf.Affiliation Value:org1.department1 ECert:true} {Name:hf.Registrar.Roles Value:client ECert:false} {Name:hf.Revoker Value:true ECert:false} {Name:hf.EnrollmentID Value:userABC ECert:true}]"
actual=$(sort identity.txt 2>/dev/null)
[[ "$actual" = "$expected" ]]
printresult "Identity userABC was successfully created" $?

rm -rf identity.txt