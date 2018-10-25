#!/bin/bash

echo ""
echo "---> @ Bootstrapping Kubernetes Cluster"

BOOTSTRAPPER_HOME=/home/vagrant/vagrant-prov

mkdir -p ~/kube-cluster

cp $BOOTSTRAPPER_HOME/config/kube/hosts ~/kube-cluster/hosts
cp $BOOTSTRAPPER_HOME/config/kube/clean-cluster.yml ~/kube-cluster/clean-cluster.yml
ansible-playbook -i ~/kube-cluster/hosts ~/kube-cluster/clean-cluster.yml