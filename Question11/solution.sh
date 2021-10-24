fabric-ca-client enroll -u http://admin:adminpw@localhost:7054

fabric-ca-client register \
--id.name userABC \
--id.affiliation org1.department1 \
--id.attrs '"hf.Registrar.Roles=client",hf.Revoker=true,' \
--id.secret passwd \
--id.type user