INSTALL_PATH="`pwd`/local"

mkdir -p mpc-build && cd mpc-build && \
../mpc-1.0.3/configure --prefix="$INSTALL_PATH" --with-gmp="$INSTALL_PATH" --with-mpfr="$INSTALL_PATH" --enable-static --disable-shared && \
make && \
make install && \
make check -k
