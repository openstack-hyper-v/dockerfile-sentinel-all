echo "Starting up connection to $1 using name: $2"
java -jar swarm-client-1.24-jar-with-dependencies.jar -master $1 -executors 1 -password jenkins -name $2 -username jenkins

