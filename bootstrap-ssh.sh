#!/bin/bash

echo ""
echo "---> @ Bootstrapping SSH Key Access"

BOOTSTRAPPER_HOME=/vagrant

echo ""
echo "---> @ Installing Dependencies"


echo ""
echo "---> @ Reverting All Previous Changes"

echo "---> @ Hardening SSH"
mkdir -p /etc/ssh/authorized_keys
cp $BOOTSTRAPPER_HOME/config/ssh/sshd_config /etc/ssh/sshd_config
service sshd restart

echo "---> @ Moving vagrant account's Authorized Key"
cp /home/vagrant/.ssh/authorized_keys /etc/ssh/authorized_keys/vagrant
chown vagrant /etc/ssh/authorized_keys/vagrant
chmod 600 /etc/ssh/authorized_keys/vagrant

echo "---> @ Creating deploy account and adding Authorized Key"
useradd -g users deploy
cp $BOOTSTRAPPER_HOME/config/ssh/authkey /etc/ssh/authorized_keys/deploy
chown deploy /etc/ssh/authorized_keys/deploy
chmod 600 /etc/ssh/authorized_keys/deploy

echo "---> @ Adding Authorized Key for Root"
cp $BOOTSTRAPPER_HOME/config/ssh/authkey /etc/ssh/authorized_keys/root
chown root /etc/ssh/authorized_keys/root
chmod 600 /etc/ssh/authorized_keys/root
