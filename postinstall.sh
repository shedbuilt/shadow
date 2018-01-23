#!/bin/bash
# Install default passwd and group files, if necessary
SHEDPKG_INSTALLED_DEFAULTS=false
if [ ! -e /etc/passwd ]; then
    install -v -m644 /etc/passwd.default /etc/passwd
    SHEDPKG_INSTALLED_DEFAULTS=true
fi
if [ ! -e /etc/group ]; then
    install -v -m644 /etc/group.default /etc/group
    SHEDPKG_INSTALLED_DEFAULTS=true
fi
if [ "$SHED_BUILDMODE" == 'bootstrap' ] || $SHEDPKG_INSTALLED_DEFAULTS; then
    pwconv
    grpconv
    sed -i 's/yes/no/' /etc/default/useradd
    echo 'root:shedbuilt' | chpasswd
fi
