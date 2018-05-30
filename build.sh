#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
# Configure
sed -i 's/groups$(EXEEXT) //' src/Makefile.in &&
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \; &&
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \; &&
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \; &&
sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
       -e 's@/var/spool/mail@/var/mail@' etc/login.defs &&
sed -i 's/1000/999/' etc/useradd &&
./configure --sysconfdir=/etc \
            --with-group-name-max-length=32 &&
# Build and Install
make -j $SHED_NUM_JOBS &&
make DESTDIR="$SHED_FAKE_ROOT" install &&
# Rearrange
mv -v "${SHED_FAKE_ROOT}/usr/bin/passwd" "${SHED_FAKE_ROOT}/bin" &&
# Create default user skeleton
install -v -dm755 "${SHED_FAKE_ROOT}/usr/share/defaults/etc/skel/.config"
