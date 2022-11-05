#!/bin/bash

LFS=$1

if [ "$LFS" == "" ]; then
    echo "====== ERROR: LFS VARIABLE IS EMPTY! THIS IS PROBATLY AN ERROR INSIDE THE LFS.SH SCRIPT. CONINUING CAN AND WILL BREAK YOUR HOST SYSTEM"
    exit 1
fi

chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
    x86_64) chown -R root:root $LFS/lib64 ;;
esac

mkdir -pv $LFS/{dev,proc,sys,run}

mount -v --bind /dev $LFS/dev

mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
    mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi