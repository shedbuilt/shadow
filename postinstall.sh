#!/bin/bash
if [ ! -e /etc/shadow ]; then
    pwconv &&
    grpconv &&
    sed -i 's/yes/no/' /etc/default/useradd &&
    echo 'root:shedbuilt' | chpasswd
fi
