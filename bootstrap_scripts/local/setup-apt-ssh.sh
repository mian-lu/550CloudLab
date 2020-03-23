#!/bin/bash

# Number of nodes in your experiment.
NUM_NODES=$1
# Your local directory that stores the bootstrap scripts. 
LOCAL_HOME="/Users/haoyuh/Documents/PhdUSC/dblab/550/cloudlab/bootstrap_scripts"
# The directory on cloudlab that you will copy your local scripts to. 
REMOTE_HOME="/proj/bg-PG0/haoyu/550/bootstrap_scripts"
# The host name of your experiment. {experiment name}.{project name}.apt.emulab.net
host="Nova2.bg-PG0.apt.emulab.net"

ssh haoyu@node-0.${host} "mkdir -p $REMOTE_HOME"
scp -r $LOCAL_HOME/* haoyu@node-0.${host}:$REMOTE_HOME

for ((i=0;i<NUM_NODES;i++)); do
    echo "building node $i"
    ssh -oStrictHostKeyChecking=no haoyu@node-$i.${host} "bash $REMOTE_HOME/local/setup-ssh.sh"
done

for ((i=0;i<NUM_NODES;i++)); do
    echo "Rebooting node $i"
    ssh -oStrictHostKeyChecking=no haoyu@node-$i.${host} "sudo cp $REMOTE_HOME/local/ulimit.conf /etc/systemd/user.conf"
    ssh -oStrictHostKeyChecking=no haoyu@node-$i.${host} "sudo cp $REMOTE_HOME/local/sys_ulimit.conf /etc/systemd/system.conf"
    ssh -oStrictHostKeyChecking=no haoyu@node-$i.${host} "sudo cp $REMOTE_HOME/local/limit.conf /etc/security/limits.conf"
    # ssh -oStrictHostKeyChecking=no haoyu@node-$i.${host} "sudo reboot"
done
