INSTALL_PATH="`pwd`/local"

mkdir -p "$INSTALL_PATH" && \
mkdir -p  w32api-build && cd  w32api-build && \
../w32api-5.3.4/configure --prefix="$INSTALL_PATH" && \
make && \
make install && \
make check -k
