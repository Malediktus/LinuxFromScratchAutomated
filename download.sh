cat packages.csv | while read line; do
    NAME="`echo $line | cut -d\; -f1`"
    VERSION="`echo $line | cut -d\; -f2`"
    URL="`echo $line | cut -d\; -f3 | sed "s/@/$VERSION/g"`"
    MD5SUM="`echo $line | cut -d\; -f4`"

    CACHEFILE="$(basename "$URL")"

    if [ ! -f "$CACHEFILE" ]; then
        echo "====== DOWNLOADING $NAME"
        wget "$URL"
        if ! echo "$MD5SUM $CACHEFILE" | md5sum -c > /dev/null; then
            rm -f "$CACHEFILE"
            echo "====== ERROR: MD5SUM MISMATCH: PACKAGE: $NAME VERSION: $VERSION URL: $URL"
            exit 1
        fi
    fi

done