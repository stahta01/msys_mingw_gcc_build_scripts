INSTALL_PATH='/usr/local'

./build-w32api.sh "$INSTALL_PATH" && \
./build-mingwrt.sh "$INSTALL_PATH" && \
./build-binutils.sh "$INSTALL_PATH" && \
./build-gcc.sh "$INSTALL_PATH"
