set -e

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make -j2
make DESTDIR=$LFS install -j2