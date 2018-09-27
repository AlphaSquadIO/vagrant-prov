#!/bin/bash

if grep -Fxq "$workspace" /etc/hosts
then
    echo "Configuration already added"
else
    echo "Configuration NOT Yet added"
    echo '192.168.100.101 workspace' >> /etc/hosts
	echo '192.168.100.210 kmaster' >> /etc/hosts
	echo '192.168.100.201 kworker01lx' >> /etc/hosts
	echo '192.168.100.202 kworker02lx' >> /etc/hosts
fi

