#!/bin/bash

echo ""
echo "---> @ Bootstrapping Kubernetes Cluster"

BOOTSTRAPPER_HOME=/home/vagrant/vagrant-prov

mkdir -p ~/kube-cluster

cp $BOOTSTRAPPER_HOME/config/kube/hosts ~/kube-cluster/hosts
cp $BOOTSTRAPPER_HOME/config/kube/kube-dependencies.yml ~/kube-cluster/kube-dependencies.yml
ansible-playbook -i ~/kube-cluster/hosts ~/kube-cluster/kube-dependencies.yml

cp $BOOTSTRAPPER_HOME/config/kube/master.yml ~/kube-cluster/master.yml
ansible-playbook -i ~/kube-cluster/hosts ~/kube-cluster/master.yml

cp $BOOTSTRAPPER_HOME/config/kube/workers.yml ~/kube-cluster/workers.yml
ansible-playbook -i ~/kube-cluster/hosts ~/kube-cluster/workers.yml