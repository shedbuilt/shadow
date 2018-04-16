#!/bin/bash
# Install default passwd and group files, if necessary
SHED_PKG_INSTALLED_DEFAULTS=false
if [ ! -e /etc/passwd ]; then
    install -v -m644 /usr/share/defaults/etc/passwd /etc/passwd
    SHED_PKG_INSTALLED_DEFAULTS=true
fi
if [ ! -e /etc/group ]; then
    install -v -m644 /usr/share/defaults/etc/group /etc/group
    SHED_PKG_INSTALLED_DEFAULTS=true
fi
if [ "$SHED_BUILD_MODE" == 'bootstrap' ] || $SHED_PKG_INSTALLED_DEFAULTS; then
    pwconv
    grpconv
    sed -i 's/yes/no/' /etc/default/useradd
    echo 'root:shedbuilt' | chpasswd
    install -v -dm755 /root/.config
fi
