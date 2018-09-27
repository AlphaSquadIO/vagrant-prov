#!/bin/bash

echo ""
echo "---> @ Bootstrapping Ansible"

NUM_OF_KWORKERS=${1:-2}

yum -y install ansible


if grep -Fxq "$kmaster" /etc/ansible/hosts
then
    echo "Configuration already added"
else
	echo "Configuration NOT Yet added. Adding now..."
	echo "kmaster" >> /etc/ansible/hosts

	for (( c=1; c<=$NUM_OF_KWORKERS; c++ ))
	do
		echo "kworker0${c}lx" >> /etc/ansible/hosts
	done
fi
