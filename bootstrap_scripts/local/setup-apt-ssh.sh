#!/bin/bash

# Number of nodes in your experiment.
NUM_NODES=$1
# Your local directory that stores the bootstrap scripts.
LOCAL_HOME="/home/mlu/cs550/GitHubRepos/mianlu/550CloudLab/bootstrap_scripts"
# The directory on cloudlab that you will copy your local scripts to.
REMOTE_HOME="/proj/nova-PG0/mianlusc/cs550/bootstrap_scripts"
# The host name of your experiment. {experiment name}.{project name}.apt.emulab.net
host="mlrdmat.nova-PG0.apt.emulab.net"

ssh -oStrictHostKeyChecking=no mianlusc@node-0.${host} "mkdir -p $REMOTE_HOME"
scp -r $LOCAL_HOME/* mianlusc@node-0.${host}:$REMOTE_HOME

for ((i=0;i<NUM_NODES;i++)); do
    echo "building node $i"
    ssh -oStrictHostKeyChecking=no mianlusc@node-$i.${host} "bash $REMOTE_HOME/local/setup-ssh.sh"
done

for ((i=0;i<NUM_NODES;i++)); do
    echo "Rebooting node $i"
    ssh -oStrictHostKeyChecking=no mianlusc@node-$i.${host} "sudo cp $REMOTE_HOME/local/ulimit.conf /etc/systemd/user.conf"
    ssh -oStrictHostKeyChecking=no mianlusc@node-$i.${host} "sudo cp $REMOTE_HOME/local/sys_ulimit.conf /etc/systemd/system.conf"
    ssh -oStrictHostKeyChecking=no mianlusc@node-$i.${host} "sudo cp $REMOTE_HOME/local/limit.conf /etc/security/limits.conf"
    # ssh -oStrictHostKeyChecking=no mianlusc@node-$i.${host} "sudo reboot"
done
