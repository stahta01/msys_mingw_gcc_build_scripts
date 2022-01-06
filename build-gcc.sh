_apply_patch_with_msg() {
  for _patch in "$@"
  do
    echo "Applying ${_patch}"
    patch --directory=${_gcc_folder} -Nbp1 -i "../patches/gcc/${_patch}"
  done
}

_patch_gcc() {
  _apply_patch_with_msg \
    01-mingw-w64-brain-damage.patch \
    02-mingw32-float.h.patch \
    03-ada-largefile.patch \
    04-eh-frame-begin.patch \
    06-ssp-wincrypt.patch \
    07-libcaf-libtool.patch \
    08-ada-gnattools.patch \
    09-ada-unicode-misuse.patch \
    10-mingw-wformat.patch \
    11-libobjc-install-strip.patch \
    14-mingw-ansi-stdio-misuse.patch \
    15-ada-sockets-wspiapi-support.patch \
    16-gratuitous-vista-usage.patch \
    17-bogus-winsup-references.patch \
    18-mingw32-libgcc-specs.patch \
    19-libgnat-win32-import-libs.patch \
    20-libiberty-mingw-host-shared.patch \
    21-libgccjit-win32-fchmod.patch \
    22-libgccjit-win32-dlfcn.patch \
    23-libgccjit-win32-no-pthreads.patch \
    24-libgccjit-full-driver-name.patch \
    25-libgccjit-mingw-link-options.patch \
    26-libgccjit-mingw-host-shared.patch \
    27-libgccjit-invalid-assertion.patch \
    28-fancy-abort-diagnostic.patch \
    29-libgccjit-file-mode.patch

  sed -i 's/${prefix}\/mingw\//${prefix}\//g' ${_gcc_folder}/configure
}

if [[ $# -ne 0 ]]; then
  INSTALL_PATH="$1"
else
  INSTALL_PATH="`pwd`/local"
fi
_gcc_folder="gcc-9.2.0"

[[ -d gcc-build ]] && rm -rf gcc-build

pwd && \
_patch_gcc && \
mkdir -p gcc-build && cd gcc-build && \
date --rfc-3339=seconds > ../gcc-build.log && \
../${_gcc_folder}/configure --prefix="$INSTALL_PATH" \
  --with-build-sysroot="$INSTALL_PATH" \
  --with-build-time-tools="$INSTALL_PATH/bin" \
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
