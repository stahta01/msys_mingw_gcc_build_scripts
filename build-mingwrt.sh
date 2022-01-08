if [[ $# -ne 0 ]]; then
  INSTALL_PATH="$1"
else
  INSTALL_PATH='/usr/local'
fi

mkdir -p "$INSTALL_PATH" && \
mkdir -p  mingwrt-build && cd  mingwrt-build && \
../mingwrt-5.4.2/configure --build=i686-pc-mingw32 --prefix="$INSTALL_PATH" && \
make && \
make install && \
make check
