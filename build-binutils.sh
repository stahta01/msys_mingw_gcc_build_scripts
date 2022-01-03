INSTALL_PATH="`pwd`/local"

mkdir -p binutils-build && cd binutils-build && \
../binutils-2.32/configure --prefix="$INSTALL_PATH" --with-libiconv-prefix="$INSTALL_PATH" --with-libintl-prefix="$INSTALL_PATH" --enable-nls --disable-werror && \
make && \
make install && \
make check -k
