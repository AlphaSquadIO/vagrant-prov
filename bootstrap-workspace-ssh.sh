#!/bin/bash

echo ""
echo "---> @ Bootstrapping SSH Key Access"

NUM_OF_KWORKERS=${1:-2}

KMASTER_IP=192.168.100.210
KWORKER_PREFIX_IP=192.168.100.20

echo ""
echo "---> @ Installing Dependencies"


echo ""
echo "---> @ Reverting All Previous Changes"
if [ -f ~/.ssh/id_rsa_workspace_kmaster_root ] 
then
	rm ~/.ssh/id_rsa_workspace_kmaster_root
fi

if [ -f ~/.ssh/id_rsa_workspace_kmaster_deploy ] 
then
	rm ~/.ssh/id_rsa_workspace_kmaster_deploy
fi

for (( c=1; c<=$NUM_OF_KWORKERS; c++ ))
do 
	if [ -f ~/.ssh/id_rsa_workspace_kworker0${c}lx_root ] 
	then
		rm ~/.ssh/id_rsa_workspace_kworker0${c}lx_root
	fi
done

echo "---> @ Generating SSH Key Pair for Workspace to Connect to KMaster using Root Account"
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa_workspace_kmaster_root
echo "---> @ Copying Root Account's SSH Authorized Key to KMaster"
scp -i /vagrant/config/ssh/idkey ~/.ssh/id_rsa_workspace_kmaster_root.pub root@$KMASTER_IP:/etc/ssh/authorized_keys/root

echo "---> @ Generating SSH Key Pair for Workspace to Connect to KMaster using Deploy Account"
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa_workspace_kmaster_deploy
echo "---> @ Copying Deploy Account's SSH Authorized Key to KMaster"
scp -i /vagrant/config/ssh/idkey ~/.ssh/id_rsa_workspace_kmaster_deploy.pub deploy@$KMASTER_IP:/etc/ssh/authorized_keys/deploy

for (( c=1; c<=$NUM_OF_KWORKERS; c++ ))
do  
	echo "---> @ Generating SSH Key Pair for Workspace to Connect to KWorker0${c}lx using Root Account"
	ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa_workspace_kworker0${c}lx_root
	echo "---> @ Copying Root Account's SSH Authorized Key to KMaster"
	scp -i /vagrant/config/ssh/idkey ~/.ssh/id_rsa_workspace_kworker0${c}lx_root.pub root@$KWORKER_PREFIX_IP$c:/etc/ssh/authorized_keys/root
done