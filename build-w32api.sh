if [[ $# -ne 0 ]]; then
  INSTALL_PATH="$1"
else
  INSTALL_PATH='/usr/local'
fi

mkdir -p "$INSTALL_PATH" && \
mkdir -p  w32api-build && cd  w32api-build && \
../w32api-5.3.4/configure --prefix="$INSTALL_PATH" && \
make && \
make install && \
make check -k
