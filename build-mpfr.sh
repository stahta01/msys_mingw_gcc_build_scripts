INSTALL_PATH="`pwd`/local"

mkdir -p mpfr-build && cd mpfr-build && \
../mpfr-3.1.4/configure --prefix="$INSTALL_PATH" --with-gmp="$INSTALL_PATH" --enable-thread-safe --enable-static --disable-shared && \
make && \
make install && \
make check -k
