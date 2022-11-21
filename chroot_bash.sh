#!/bin/bash

LFS=$1

if [ "$LFS" == "" ]; then
    echo "====== ERROR: LFS VARIABLE IS EMPTY! THIS IS PROBATLY AN ERROR INSIDE THE LFS.SH SCRIPT. CONINUING CAN AND WILL BREAK YOUR HOST SYSTEM"
    exit 1
fi

cp -rf *.sh chapter* packages.csv "$LFS/sources"

chmod ugo+x preparechroot.sh
sudo ./preparechroot.sh "$LFS"

sudo chroot "$LFS" /usr/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    PS1="(lfs chroot) \u:\w\$ " \
    PATH="/bin:/usr/bin:/sbin:/usr/sbin" \
    /bin/bash --login

chmod ugo+x teardownchroot.sh
sudo ./teardownchroot.sh "$LFS"