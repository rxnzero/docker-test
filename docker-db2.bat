docker run -itd --name testdb --privileged=true -p 50000:50000 -e LICENSE=accept -e DB2INST1_PASSWORD=db2inst1 -e DBNAME=testdb -e PERSISTENT_HOME=false -v d:\db2\storage:/database ibmcom/db2