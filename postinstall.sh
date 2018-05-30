#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
# Install default passwd and group files, if necessary
SHED_PKG_LOCAL_INSTALLED_DEFAULTS=false
if [ ! -e /etc/passwd ]; then
    install -v -m644 /usr/share/defaults/etc/passwd /etc/passwd || exit 1
    SHED_PKG_LOCAL_INSTALLED_DEFAULTS=true
fi
if [ ! -e /etc/group ]; then
    install -v -m644 /usr/share/defaults/etc/group /etc/group || exit 1
    SHED_PKG_LOCAL_INSTALLED_DEFAULTS=true
fi
if [ ! -d /etc/skel ]; then
    ln -sfv /usr/share/defaults/etc/skel /etc/skel || exit 1
fi
if [ -n "${SHED_PKG_LOCAL_OPTIONS[bootstrap]}" ] || $SHED_PKG_LOCAL_INSTALLED_DEFAULTS; then
    pwconv &&
    grpconv &&
    sed -i 's/yes/no/' /etc/default/useradd &&
    echo 'root:shedbuilt' | chpasswd &&
    cp -a /usr/share/defaults/etc/skel/. /root
fi
