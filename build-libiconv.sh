INSTALL_PATH="`pwd`/local"

mkdir -p "$INSTALL_PATH" && \
mkdir -p libiconv-build && cd libiconv-build && \
../libiconv-1.16/configure --prefix="$INSTALL_PATH" --enable-shared --disable-static --disable-nls && \
make && \
make install && \
make check -k
