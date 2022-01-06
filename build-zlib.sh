if [[ $# -ne 0 ]]; then
  INSTALL_PATH="$1"
else
  INSTALL_PATH='/usr/local'
fi

mkdir -p "$INSTALL_PATH" && \
cd zlib-1.2.11 && \
make -f win32/Makefile.gcc prefix=$INSTALL_PATH && \
make -f win32/Makefile.gcc install DESTDIR=$INSTALL_PATH INCLUDE_PATH=/include LIBRARY_PATH=/lib  BINARY_PATH=/bin && \
make -f win32/Makefile.gcc test -k
