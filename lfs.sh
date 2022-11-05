#!/bin/bash

export LFS=/mnt/lfs
export LFS_TGT=x86_64-lfs-linux-gnu
export LFS_DISK=/dev/sdb
export MAKEFLAGS='-j2'

set -e

if ! grep -q "$LFS" /proc/mounts; then
    echo "====== DEBUG MESSAGE: DONT FORGET TO MOUNT THE DISK"
    exit 0
    echo "====== FORMATING DISK"
    source setupdisk.sh "$LFS_DISK" | tee "diskpart.log"
    sudo mount "${LFS_DISK}2" "$LFS"
    sudo chown -v "$USER" "$LFS"
fi

echo "====== SETTING UP THE ROOT FS"
mkdir -pv "$LFS/sources"
mkdir -pv "$LFS/tools"

mkdir -pv "$LFS/boot"
mkdir -pv "$LFS/etc"
mkdir -pv "$LFS/bin"
mkdir -pv "$LFS/lib"
mkdir -pv "$LFS/sbin"
mkdir -pv "$LFS/usr"
mkdir -pv "$LFS/var"

mkdir -pv "$LFS/sources/log"

case $(uname -m) in
    x86_64) mkdir -pv "$LFS/lib64";;
esac

echo "====== MOVING TO THE MOUNT POINT"

cp -rf *.sh chapter* packages.csv "$LFS/sources"
cd "$LFS/sources"
export PATH="$LFS/tools/bin:$PATH"


echo "====== DOWNLOADING PACKAGE SOURCE CODES"
if ! source download.sh | tee "./log/download.log"; then
    echo "====== UNKOWN ERROR WHILE DOWNLOADING SOURCES"
    exit 1
fi

echo "====== COMPILING BINUTILS, GCC, LINUX-HEADERS, GLIBC, LIBSTDC++ FOR CHAPTER 5"
# Chapter 5
for package in binutils gcc linux-api-headers glibc libstdc++; do
    if ! source packageinstall.sh 5 $package; then
        echo "====== UNKOWN ERROR WHILE COMPILING PACKAGE"
        exit 1
    fi
done

echo "====== COMPILING BINUTILS, GCC, M4, GAWK, MAKE, PATCH, ... FOR CHAPTER 6"
# Chapter 6
for package in m4 ncurses bash coreutils diffutils file findutils gawk grep gzip make patch sed tar xz binutils gcc; do
    if ! source packageinstall.sh 6 $package; then
        echo "====== UNKOWN ERROR WHILE COMPILING PACKAGE"
        exit 1
    fi
done

chmod +x preparechroot.sh
chmod +x insidechroot.sh
sudo ./preparechroot.sh "$LFS"


echo "====== ENTERING THE CHROOT ENVIRONMENT"
sleep 5

sudo chroot "$LFS" /usr/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    PS1="(lfs chroot) \u:\w\$ " \
    PATH="/bin:/usr/bin:/sbin:/usr/sbin" \
    /bin/bash --login +h -c "/sources/insidechroot.sh"