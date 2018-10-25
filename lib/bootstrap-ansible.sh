#!/bin/bash

echo ""
echo "---> @ Bootstrapping Ansible"

KUBE_SETUP=$1

NUM_OF_KWORKERS=${1:-2}

yum -y install ansible


if grep -q "kmaster" /etc/ansible/hosts
then
    echo "Configuration already added"
else
	echo "Configuration NOT Yet added."

 	if [ '$KUBE_SETUP' == 'true' ]
 	then
 		echo "Adding now..."
		echo "kmaster" >> /etc/ansible/hosts

		for (( c=1; c<=$NUM_OF_KWORKERS; c++ ))
		do
			echo "kworker0${c}lx" >> /etc/ansible/hosts
		done

	fi
fi
