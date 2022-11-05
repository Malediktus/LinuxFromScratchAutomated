set -e

make mrproper -j2
make headers -j2
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr