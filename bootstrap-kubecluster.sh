#!/bin/bash

echo ""
echo "---> @ Bootstrapping Kubernetes Cluster"

NUM_OF_KWORKERS=${1:-2}
BOOTSTRAPPER_HOME=/vagrant

mkdir -p ~/kube-cluster

cp $BOOTSTRAPPER_HOME/config/kube/hosts ~/kube-cluster/hosts
cp $BOOTSTRAPPER_HOME/config/kube/kube-dependencies.yml ~/kube-cluster/kube-dependencies.yml
ansible-playbook -i ~/kube-cluster/hosts ~/kube-cluster/kube-dependencies.yml

cp $BOOTSTRAPPER_HOME/config/kube/master.yml ~/kube-cluster/master.yml
ansible-playbook -i ~/kube-cluster/hosts ~/kube-cluster/master.yml