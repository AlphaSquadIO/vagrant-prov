#!/bin/bash

echo ""
echo "---> @ Regenerating SSH Keys for Workspace Access to Nodes in Kubernetes Cluster"

NUM_OF_KWORKERS=${1:-2}
BOOTSTRAPPER_HOME=/vagrant

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
scp -i /vagrant/config/ssh/idkey ~/.ssh/id_rsa_workspace_kmaster_root.pub root@kmaster:/etc/ssh/authorized_keys/root

echo "---> @ Generating SSH Key Pair for Workspace to Connect to KMaster using Deploy Account"
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa_workspace_kmaster_deploy
echo "---> @ Copying Deploy Account's SSH Authorized Key to KMaster"
scp -i /vagrant/config/ssh/idkey ~/.ssh/id_rsa_workspace_kmaster_deploy.pub deploy@kmaster:/etc/ssh/authorized_keys/deploy

for (( c=1; c<=$NUM_OF_KWORKERS; c++ ))
do  
	echo "---> @ Generating SSH Key Pair for Workspace to Connect to KWorker0${c}lx using Root Account"
	ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa_workspace_kworker0${c}lx_root
	echo "---> @ Copying Root Account's SSH Authorized Key to KMaster"
	scp -i /vagrant/config/ssh/idkey ~/.ssh/id_rsa_workspace_kworker0${c}lx_root.pub root@kworker0${c}lx:/etc/ssh/authorized_keys/root
done

cp $BOOTSTRAPPER_HOME/config/ssh/workspace_root_ssh_config ~/.ssh/config