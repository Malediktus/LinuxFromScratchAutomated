./configure --prefix=/usr    \
--enable-cxx     \
--disable-static \
--docdir=/usr/share/doc/gmp-6.2.1

make
make html

make install
make install-html