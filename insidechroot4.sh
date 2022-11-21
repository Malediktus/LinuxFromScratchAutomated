export LFS=""
cd /sources

# TODO: Get device name and MAC Address from ip a and a grep/gawk script

cat > /etc/systemd/network/10-enp0s3.link << "EOF"
[Match]
# Change the MAC address as appropriate for your network device
MACAddress=08:00:27:24:bf:eb

[Link]
Name=enp0s3
EOF

cat > /etc/systemd/network/10-eth-dhcp.network << "EOF"
[Match]
Name=enp0s3

[Network]
DHCP=ipv4

[DHCP]
UseDomains=false
EOF

echo "lfsbox" > /etc/hostname

cat > /etc/hosts << "EOF"
# Begin /etc/hosts

127.0.0.1 localhost
::1       localhost ip6-localhost ip6-loopback
ff02::1   ip6-allnodes
ff02::2   ip6-allrouters

# End /etc/hosts
EOF

cat > /etc/adjtime << "EOF"
0.0 0 0.0
0
LOCAL
EOF

# TODO: Add clock configs

cat > /etc/vconsole.conf << "EOF"
KEYMAP=de-latin1
FONT=Lat2-Terminus16
EOF

localectl set-keymap de-latin1
localectl set-x11-keymap de-latin1 # TODO: Test

LC_ALL=en_US.utf8 locale language
LC_ALL=de_DE.utf8 locale charmap
LC_ALL=de_DE.utf8 locale int_curr_symbol
LC_ALL=en_US.utf8 locale int_prefix

cat > /etc/locale.conf << "EOF"
LANG=en_US.utf8
EOF

localectl set-locale LANG="en_US.UTF-8" LC_CTYPE="en_US"

cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8-bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF

cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF

mkdir -pv /etc/systemd/system/getty@tty1.service.d

cat > /etc/systemd/system/getty@tty1.service.d/noclear.conf << EOF
[Service]
TTYVTDisallocate=yes # TODO: Ask the user a prompt
EOF

# mkdir -pv /etc/systemd/system/foobar.service.d
# 
# cat > /etc/systemd/system/foobar.service.d/foobar.conf << EOF
# [Service]
# Restart=always
# RestartSec=30
# EOF

mkdir -pv /etc/systemd/coredump.conf.d

cat > /etc/systemd/coredump.conf.d/maxuse.conf << EOF
[Coredump]
MaxUse=1G
EOF