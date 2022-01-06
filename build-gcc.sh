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

if [[ $# -ne 0 ]]; then
  INSTALL_PATH="$1"
else
  INSTALL_PATH="`pwd`/local"
fi
_gcc_folder="gcc-9.2.0"

[[ -d gcc-build ]] && rm -rf gcc-build

pwd && \
date --rfc-3339=seconds > gcc-prepare.log && \
cd ${_gcc_folder} && _patch_gcc | tee ../gcc-prepare.log && cd .. && \
date --rfc-3339=seconds >> ../gcc-prepare.log
mkdir -p gcc-build && cd gcc-build && \
date --rfc-3339=seconds > ../gcc-build.log && \
../${_gcc_folder}/configure --prefix="$INSTALL_PATH" \
  --with-build-time-tools="$INSTALL_PATH/bin" \
  --with-libiconv-prefix="$INSTALL_PATH" --with-libintl-prefix="$INSTALL_PATH" \
  --with-gmp="$INSTALL_PATH" --with-mpfr="$INSTALL_PATH" --with-mpc="$INSTALL_PATH" \
  --with-dwarf2 --disable-sjlj-exceptions \
  --enable-languages=c,c++,ada \
  --enable-static --enable-shared \
  --disable-libvtv --disable-win32-registry \
  --disable-nls --disable-werror --disable-build-format-warnings 2>&1 | tee ../gcc-build.log && \
make 2>&1 | tee ../gcc-build.log && \
date --rfc-3339=seconds >> ../gcc-build.log && \
make install && \
make check -k


# --with-build-sysroot="$INSTALL_PATH"
