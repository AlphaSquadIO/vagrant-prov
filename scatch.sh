#!/bin/bash

yum install dkms gcc make kernel-devel bzip2 binutils patch libgomp glibc-headers glibc-devel kernel-headers
mkdir -p /media/cdrom
mount /dev/scd0 /media/cdrom
sh /media/cdrom/VBoxLinuxAdditions.run