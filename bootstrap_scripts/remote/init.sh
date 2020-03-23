#!/bin/bash

# The directory on cloudlab that contains the bootstrap scripts.
REMOTE_HOME="/proj/bg-PG0/haoyu/550/bootstrap_scripts/remote"

NUM_NODES=$1

for ((i=0;i<NUM_NODES;i++)); do
	echo "*******************************************"
	echo "*******************************************"
   	echo "******************* Installing libraries for node-$i ********************"
   	echo "*******************************************"
   	echo "*******************************************"
 	ssh -oStrictHostKeyChecking=no node-$i "sudo apt-get update"
    ssh -oStrictHostKeyChecking=no node-$i "sudo apt-get --yes install screen"
    ssh -n -f -oStrictHostKeyChecking=no node-$i screen -L -S env1 -dm "$REMOTE_HOME/env0.sh"
done

sleep 10

sleepcount="0"
for ((i=0;i<NUM_NODES;i++)); 
do
	while ssh -oStrictHostKeyChecking=no  node-$i "screen -list | grep -q env1"
	do 
		((sleepcount++))
		sleep 10
		echo "waiting for node-$i to install libraries"
	done

done

echo "init env took $((sleepcount/6)) minutes"
