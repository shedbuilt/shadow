#!/bin/bash
if [ "$SHED_BUILDMODE" == 'bootstrap' ]; then
    pwconv
    grpconv
    sed -i 's/yes/no/' /etc/default/useradd
    echo 'root:shedbuilt' | chpasswd
fi
