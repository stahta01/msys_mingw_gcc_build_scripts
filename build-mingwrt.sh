INSTALL_PATH="`pwd`/local"

mkdir -p "$INSTALL_PATH" && \
mkdir -p  mingwrt-build && cd  mingwrt-build && \
../mingwrt-5.4.2/configure --prefix="$INSTALL_PATH" && \
make && \
make install && \
make check -k
