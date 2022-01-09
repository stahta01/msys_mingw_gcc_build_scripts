_apply_patch_with_msg() {
  for _patch in "$@"
  do
    if [ ! -f "../patches/gcc/${_patch}" ]; then
      echo "Skipping ${_patch} because it is missing" 2>&1
    elif patch --dry-run -Rbp1 -i "../patches/gcc/${_patch}" > /dev/null 2>&1 ; then
      echo "Skipping ${_patch} because it likely was already applied" 2>&1
    elif patch --dry-run -Nbp1 -i "../patches/gcc/${_patch}" > /dev/null 2>&1 ; then
      echo "Applying ${_patch}"
      patch -Nbp1 -i "../patches/gcc/${_patch}" 2>&1
    else
      echo "Skipping ${_patch} because it likely will fail" 2>&1
    fi
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
}

_prepare_gcc() {
  cd ${_gcc_folder} && \
  date --rfc-3339=seconds && \
  _patch_gcc && \
  date --rfc-3339=seconds && \
  cd ..
}

_build_boot_gcc() {
  date --rfc-3339=seconds && \
  touch -a "$INSTALL_PATH"/include/features.h && \
  ../${_gcc_folder}/configure --build=mingw32 \
    --prefix="$INSTALL_PATH" \
    --with-dwarf2 --disable-sjlj-exceptions \
    --disable-bootstrap \
    --enable-languages=c,c++ \
    --enable-static --enable-shared --disable-lto \
    --enable-version-specific-runtime-libs \
    --enable-checking=release \
    --disable-libvtv --disable-win32-registry \
    --disable-nls --disable-werror --disable-build-format-warnings && \
  make && \
  date --rfc-3339=seconds
}

if [[ $# -ne 0 ]]; then
  INSTALL_PATH="$1"
else
  INSTALL_PATH='/usr/local'
fi
_gcc_folder="gcc-9.2.0"

echo "INSTALL_PATH := $INSTALL_PATH"
echo "_gcc_folder := ${_gcc_folder}"

[[ -d gcc-build ]] && rm -rf gcc-build

_prepare_gcc 2>&1 | tee gcc-prepare.log && \
mkdir -p gcc-build && cd gcc-build && \
mkdir -p /mingw/include && \
_build_boot_gcc 2>&1 | tee ../gcc-boot-build.log && \
make install && \
make check




# --with-gmp="$INSTALL_PATH"
# --with-mpfr="$INSTALL_PATH" 
# --with-mpc="$INSTALL_PATH"
# --with-build-sysroot="$INSTALL_PATH"
# --with-libiconv-prefix="$INSTALL_PATH" 
# --with-libintl-prefix="$INSTALL_PATH"
# --with-stage1-ldflags="-L$INSTALL_PATH/lib/"
# --with-build-time-tools="$INSTALL_PATH/bin"
# --libexecdir=${INSTALL_PATH}/lib
