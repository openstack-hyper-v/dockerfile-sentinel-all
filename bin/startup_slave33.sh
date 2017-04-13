#!/bin/bash
echo Starting up connection to $1 using name: $2  
java -jar swarm-client-3.3.jar -master $1 -executors 2 -name $2 
