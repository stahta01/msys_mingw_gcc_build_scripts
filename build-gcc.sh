INSTALL_PATH="`pwd`/local"

[[ -d gcc-build ]] && rm -rf gcc-build && \
mkdir -p gcc-build && cd gcc-build && \
date --rfc-3339=seconds > ../gcc-build.log && \
../gcc-9.2.0/configure --prefix="$INSTALL_PATH" \
  --with-libiconv-prefix="$INSTALL_PATH" --with-libintl-prefix="$INSTALL_PATH" \
  --with-gmp="$INSTALL_PATH" --with-mpfr="$INSTALL_PATH" --with-mpc="$INSTALL_PATH" \
  --enable-static --enable-shared \
  --disable-libvtv --disable-win32-registry \
  --with-dwarf2 --disable-sjlj-exceptions \
  --enable-languages=c,c++ \
  --enable-nls --disable-werror --disable-build-format-warnings 2>&1 | tee ../gcc-build.log && \
make 2>&1 | tee ../gcc-build.log && \
date --rfc-3339=seconds >> ../gcc-build.log && \
make install && \
make check -k
