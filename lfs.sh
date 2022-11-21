#!/bin/bash

export LFS=/mnt/lfs
export LFS_TGT=x86_64-lfs-linux-gnu
export LFS_DISK=/dev/sdb # TODO: Prompt the user
export MAKEFLAGS='-j12' # TODO: Get number of cores from a script

set -e

if ! grep -q "$LFS" /proc/mounts; then
#    echo "====== DEBUG MESSAGE: DONT FORGET TO MOUNT THE DISK"
#    exit 0
    echo "====== FORMATING DISK"
    source setupdisk.sh "$LFS_DISK"
    sudo mount "${LFS_DISK}2" "$LFS"
    mkdir -pv "$LFS/boot"
    sudo mount "${LFS_DISK}1" "$LFS/boot"
    sudo chown -v "$USER" "$LFS"

    echo "====== SETTING UP THE ROOT FS"
    mkdir -pv "$LFS/sources"
    mkdir -pv "$LFS/tools"

    mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

    for i in bin lib sbin; do
    ln -sv usr/$i $LFS/$i
    done

    case $(uname -m) in
    x86_64) mkdir -pv $LFS/lib64 ;;
    esac
fi

echo "====== MOVING TO THE MOUNT POINT"
cp -rf *.sh chapter* packages.csv "$LFS/sources"
cd "$LFS/sources"
export PATH="$LFS/tools/bin:$PATH"


echo "====== DOWNLOADING PACKAGE SOURCE CODES"
if ! source download.sh; then
    echo "====== UNKOWN ERROR WHILE DOWNLOADING SOURCES"
    exit 1
fi

echo "====== COMPILING BINUTILS, GCC, LINUX-HEADERS, GLIBC, LIBSTDC++ FOR CHAPTER 5"
# Chapter 5
#for package in binutils gcc linux-api-headers glibc libstdc++; do
#    if ! source packageinstall.sh 5 $package; then
#        echo "====== UNKOWN ERROR WHILE COMPILING PACKAGE"
#        exit 1
#    fi
#done

echo "====== COMPILING BINUTILS, GCC, M4, GAWK, MAKE, PATCH, ... FOR CHAPTER 6"
# Chapter 6
#for package in m4 ncurses bash coreutils diffutils file findutils gawk grep gzip make patch sed tar xz binutils gcc; do
#    if ! source packageinstall.sh 6 $package; then
#        echo "====== UNKOWN ERROR WHILE COMPILING PACKAGE"
#        exit 1
#    fi
#done

chmod ugo+x preparechroot.sh
chmod ugo+x insidechroot.sh
chmod ugo+x insidechroot2.sh
chmod ugo+x insidechroot3.sh
chmod ugo+x insidechroot4.sh
chmod ugo+x insidechroot5.sh
chmod ugo+x teardownchroot.sh
sudo ./preparechroot.sh "$LFS"

echo "====== ENTERING THE CHROOT ENVIRONMENT"

for script in "/sources/insidechroot.sh" "/sources/insidechroot2.sh" "/sources/insidechroot3.sh" "/sources/insidechroot4.sh" "/sources/insidechroot5.sh"; do
    sudo chroot "$LFS" /usr/bin/env -i \
        HOME=/root \
        TERM="$TERM" \
        PS1="(lfs chroot) \u:\w\$ " \
        PATH="/bin:/usr/bin:/sbin:/usr/sbin" \
        /bin/bash --login -c "$script"
done

sudo ./teardownchroot.sh "$LFS"