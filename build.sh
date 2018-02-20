#!/bin/bash
sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;
sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
       -e 's@/var/spool/mail@/var/mail@' etc/login.defs
sed -i 's/1000/999/' etc/useradd
./configure --sysconfdir=/etc \
            --with-group-name-max-length=32 && \
make -j $SHED_NUMJOBS && \
make DESTDIR="$SHED_FAKEROOT" install || exit 1
mv -v "${SHED_FAKEROOT}/usr/bin/passwd" "${SHED_FAKEROOT}/bin"
# Provide basic user skeleton
install -v -dm755 "${SHED_FAKEROOT}/etc/skel/.config"
