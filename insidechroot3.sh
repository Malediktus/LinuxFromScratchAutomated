export LFS=""
cd /sources

# Chapter 8
echo "====== COMPILING TOO MANY PACKAGES TO COUNT FOR CHAPTER 8"
for package in man-pages iana-etc glibc zlib bzip2 xz zstd file readline m4 bc flex tcl expect dejagnu binutils gmp mpfr mpc attr acl libcap shadow gcc pkg-config ncurses sed psmisc gettext bison grep bash libtool gdbm gperf expat inetutils less perl xml_parser intltool autoconf automake openssl kmod libelf libffi python wheel ninja meson coreutils check diffutils gawk finduitls groff grub gzip iproute2 kbd libpipeline make patch tar texinfo vim markupsafe jinja2 systemd d-bus man-db procps-ng util-linux e2fsprogs; do
    if ! source packageinstall.sh 8 $package; then
        echo "====== UNKOWN ERROR WHILE COMPILING PACKAGE"
        exit 1
    fi
done

source stripdebuggingsymbols.sh

rm -rf /tmp/*
find /usr/lib /usr/libexec -name \*.la -delete
find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rffind /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf