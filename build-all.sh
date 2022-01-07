INSTALL_PATH='/usr/local'

./build-w32api.sh "$INSTALL_PATH" && \
./build-mingwrt.sh "$INSTALL_PATH" && \
./build-zlib.sh "$INSTALL_PATH" && \
./build-libiconv.sh "$INSTALL_PATH" && \
./build-binutils.sh "$INSTALL_PATH" && \
./build-gmp.sh "$INSTALL_PATH" && \
./build-mpfr.sh "$INSTALL_PATH" && \
./build-mpc.sh "$INSTALL_PATH" && \
./build-gcc.sh "$INSTALL_PATH"
