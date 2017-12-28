#!/bin/bash
pwconv
grpconv
sed -i 's/yes/no/' /etc/default/useradd
# Set root password to default if not set
# read -ra PASSWDSTAT <<< $(passwd --status root) || exit 1
# if [ ${#PASSWDSTAT[@]} -gt 1 ]; then
#    if [ ${PASSWDSTAT[1]} == 'NP' ]; then
#        passwd root < "${SHED_CONTRIBDIR}/root_passwd"
#    fi
# fi
