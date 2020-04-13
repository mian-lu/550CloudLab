#!/bin/bash

# run this shell script in this format:
# bash setup-apt-ssh.sh 077 093 ...
# every 3-digit argument following the filename are
# cluster #'s from cloudlab/emulab

# This script assumes that the first arg points at
# the server that acts like "host/master". All 
# other servers are slaves.

# Number of nodes in your experiment.
NUM_NODES=$#
# insert logic here to make sure at least 2 arguments
if [ "$#" -ne 2 ]; then
    echo "You must enter exactly 2 command line arguments"
fi

# Your local directory that stores the bootstrap scripts. 
# LOCAL_HOME="/Users/haoyuh/Documents/PhdUSC/dblab/550/cloudlab/bootstrap_scripts"
LOCAL_HOME="~/cs550/github_repos/ml_550cl/550CloudLab/bootstrap_scripts"

# The directory on cloudlab that you will copy your local scripts to. 
REMOTE_HOME="/proj/mianlu/cs550/bootstrap_scripts_copied"

# The host name of your experiment. {experiment name}.{project name}.apt.emulab.net
# NODE0=$2
# NODE1=$3
# host="apt$NODE0.apt.emulab.net"
# don't use this block above... use loop to construct the host string
$prefix="apt"
# insert argument 1, 2, 3...
$postfix=".apt.emulab.net"

MASTER=$1

ssh mianlusc@node-0.${host} "mkdir -p $REMOTE_HOME"
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

