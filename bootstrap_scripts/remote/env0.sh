#!/bin/bash
# The directory on cloudlab that contains the bootstrap scripts.
REMOTE_HOME="/proj/nova-PG0/mianlusc/cs550/bootstrap_scripts/remote"

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
bash $REMOTE_HOME/setup-rdma.sh


nic=`netstat -i`
echo "$nic"
IFS=' ' read -r -a array <<< $nic
echo "${array[0]}"
echo "${#array[@]}"
iface=""
for element in "${array[@]}"
do
    if [[ $element == *"enp"* ]]; then
        echo "awefwef:$element"
        iface=$element
    fi
done
echo $iface

# Optimize parameters for NICs.
bash $REMOTE_HOME/nic.sh -i $iface
bash $REMOTE_HOME/sysctl.sh

sudo apt-get --yes install screen
sudo apt-get --yes install htop
sudo apt-get --yes install maven
sudo apt-get --yes install cmake
sudo apt-get --yes install run-one

sudo apt-get --yes install elfutils

sudo su -c "echo 'logfile /tmp/screenlog' >> /etc/screenrc"

sudo apt-get install -y software-properties-common #python-software-properties debconf-utils
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get --yes install openjdk-8-jdk
sudo apt-get install -y sysstat

# Enable gdb history
echo 'set history save on' >> ~/.gdbinit && chmod 600 ~/.gdbinit

