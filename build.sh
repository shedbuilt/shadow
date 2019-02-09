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
if [ -n "${SHED_PKG_LOCAL_OPTIONS[pam]}" ]; then
    install -v -dm755 "${SHED_FAKE_ROOT}${SHED_PKG_DEFAULTS_INSTALL_DIR}"/etc/{default,pam.d} &&
    install -v -m644 "${SHED_PKG_CONTRIB_DIR}"/* "${SHED_FAKE_ROOT}${SHED_PKG_DEFAULTS_INSTALL_DIR}"/etc/pam.d || exit 1
else
    install -v -dm755 "${SHED_FAKE_ROOT}${SHED_PKG_DEFAULTS_INSTALL_DIR}"/etc/default &&
    install -v -m644 "${SHED_FAKE_ROOT}"/etc/limits "${SHED_FAKE_ROOT}${SHED_PKG_DEFAULTS_INSTALL_DIR}"/etc &&
    install -v -m644 "${SHED_FAKE_ROOT}"/etc/login.access "${SHED_FAKE_ROOT}${SHED_PKG_DEFAULTS_INSTALL_DIR}"/etc || exit 1
fi
mv -v "${SHED_FAKE_ROOT}/usr/bin/passwd" "${SHED_FAKE_ROOT}/bin" &&
install -v -m644 "${SHED_FAKE_ROOT}"/etc/default/useradd "${SHED_FAKE_ROOT}${SHED_PKG_DEFAULTS_INSTALL_DIR}"/etc/default &&
install -v -m644 "${SHED_FAKE_ROOT}"/etc/login.defs "${SHED_FAKE_ROOT}${SHED_PKG_DEFAULTS_INSTALL_DIR}"/etc &&
rm -rf "${SHED_FAKE_ROOT}"/etc
