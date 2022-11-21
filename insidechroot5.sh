export LFS=""
cd /sources

# TODO: Use swap
# NOTE: I use sda in fstab and grub.cfg because when the lfs system is booted the root disk will be sda
cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type     options             dump  fsck
#                                                              order

/dev/sda2      /            ext4     defaults            1     1
/dev/sda1      /boot        ext2     defaults            1     1
# /dev/<yyy>     swap         swap     pri=1               0     0

# End /etc/fstab
EOF

source packageinstall.sh 10 linux

grub-install /dev/sdb # TODO: Use LFS_DISK Variable (Dont now if ist still set in the chroot)

cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=10

insmod ext2
set root=(hd0,msdos1)

menuentry "LinuxFromScratch-11.2 GNU/Linux" {
        linux   /vmlinuz-5.19.2-lfs-11.2-systemd root=/dev/sda2 ro
}
EOF