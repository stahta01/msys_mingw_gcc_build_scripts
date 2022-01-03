INSTALL_PATH="`pwd`/local"

mkdir -p "$INSTALL_PATH" && \
mkdir -p gmp-build && cd gmp-build && \
../gmp-6.1.0/configure --prefix="$INSTALL_PATH" --enable-cxx --enable-assert --enable-alloca=malloc-reentrant && \
make && \
make install && \
make check -k
