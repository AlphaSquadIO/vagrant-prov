#!/bin/bash

echo ""
echo "---> @ Bootstrapping Tools for Development using Ansible"

BOOTSTRAPPER_HOME=/home/vagrant/vagrant-prov

ansible-playbook -i $BOOTSTRAPPER_HOME/config/devtools/hosts $BOOTSTRAPPER_HOME/config/devtools/devtools-dependencies.yml

ansible-galaxy install -r $BOOTSTRAPPER_HOME/config/devtools/requirements.yml
ansible-playbook -i $BOOTSTRAPPER_HOME/config/devtools/hosts $BOOTSTRAPPER_HOME/config/devtools/devtools.yml