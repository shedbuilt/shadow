#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
# Install default passwd and group files, if necessary
SHED_PKG_LOCAL_INSTALLED_DEFAULTS=false
if [ ! -e /etc/shadow ]; then
    pwconv &&
    grpconv &&
    sed -i 's/yes/no/' /etc/default/useradd &&
    echo 'root:shedbuilt' | chpasswd
fi
