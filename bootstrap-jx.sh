#!/bin/bash

echo ""
echo "---> @ Bootstrapping Jenkins X"

# (Optional argument) Specify the Jenkins X version to use. Default is the latest
JENKINSX_VERSION=$1

echo ""
echo "---> @ Installing Dependencies"
yum -y install telnet git dos2unix sshpass

if [ -z "$JENKINSX_VERSION" ]
then
	JENKINSX_VERSION=$(curl -s https://api.github.com/repos/jenkins-x/jx/releases/latest | grep tag_name | cut -d '"' -f 4)
fi
echo "*** Installing Jenkins-X $JENKINSX_VERSION ***"
mkdir -p ~/.jx/bin
curl -L https://github.com/jenkins-x/jx/releases/download/$JENKINSX_VERSION/jx-linux-amd64.tar.gz | tar xzv -C ~/.jx/bin
export PATH=$PATH:~/.jx/bin
echo 'export PATH=$PATH:~/.jx/bin' >> ~/.bashrc