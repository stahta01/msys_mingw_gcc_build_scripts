INSTALL_PATH="`pwd`/local"

mkdir -p gcc-build && cd gcc-build && \
../gcc-9.2.0/configure --prefix="$INSTALL_PATH" \
  --with-libiconv-prefix="$INSTALL_PATH" --with-libintl-prefix="$INSTALL_PATH" \
  --with-gmp="$INSTALL_PATH" --with-mpfr="$INSTALL_PATH" --with-mpc="$INSTALL_PATH" \
  --enable-static --enable-shared \
  --disable-libvtv --disable-win32-registry \
  --with-dwarf2 --disable-sjlj-exceptions \
  --enable-languages=c,c++,ada \
  --enable-nls --disable-werror --disable-build-format-warnings && \
make && \
make install && \
make check -k
