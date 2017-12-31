#!/bin/bash
pwconv
grpconv
sed -i 's/yes/no/' /etc/default/useradd
# Set root password to default if not set
ROOTSHADOW=$(grep "^root" /etc/shadow)
if [[ $ROOTSHADOW =~ ^'root:!!:' ]]; then
    echo 'root:shedbuilt' | chpasswd
fi
