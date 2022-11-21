touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp

LFS=""
cd /sources

# Chapter 7
echo "====== COMPILING MANY PACKAGES FOR CHAPTER 7"
for package in gettext bison perl python texinfo util-linux; do
    if ! source packageinstall.sh 7 $package; then
        echo "====== UNKOWN ERROR WHILE COMPILING PACKAGE"
        exit 1
    fi
done

rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete
rm -rf /tools
