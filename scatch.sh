#!/bin/bash

echo ""
echo "---> @ Bootstrapping SSH Key Access"

NUM_OF_KWORKERS=${1:-2}

KMASTER_IP=192.168.100.210
KWORKER_PREFIX_IP=192.168.100.20



for (( c=1; c<=$NUM_OF_KWORKERS; c++ ))
do  
	echo "---> @ Generating SSH Key Pair for Workspace to Connect to KWorker0${c}lx using Root Account"
	#ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa_workspace_kworker0$clx_root
	echo "---> @ Copying Root Account's SSH Authorized Key to KMaster"
	#scp -i /vagrant/config/ssh/idkey ~/.ssh/id_rsa_workspace_kworker0$clx_root.pub root@$KWORKER_PREFIX_IP$c:/etc/ssh/authorized_keys/root
done