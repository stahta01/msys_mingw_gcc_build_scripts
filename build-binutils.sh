_apply_patch_with_msg() {
  for _patch in "$@"
  do
    if [ ! -f "../patches/binutils/${_patch}" ]; then
      echo "Skipping ${_patch} because it is missing" 2>&1
    elif patch --dry-run -Rbp1 -i "../patches/binutils/${_patch}" > /dev/null 2>&1 ; then
      echo "Skipping ${_patch} because it likely was already applied" 2>&1
    elif patch --dry-run -Nbp1 -i "../patches/binutils/${_patch}" > /dev/null 2>&1 ; then
      echo "Applying ${_patch}"
      patch -Nbp1 -i "../patches/binutils/${_patch}" 2>&1
    else
      echo "Skipping ${_patch} because it likely will fail" 2>&1
    fi
  done
}

_patch_binutils() {
  _apply_patch_with_msg \
    01-mingw-win9x-fseek-hack.patch \
    02-enotsup-fall-back.patch
}

_prepare_binutils() {
  cd ${_binutils_folder} && \
  date --rfc-3339=seconds && \
  _patch_binutils && \
  date --rfc-3339=seconds && \
  cd ..
}

_build_binutils() {
  date --rfc-3339=seconds && \
  ../${_binutils_folder}/configure --prefix="$INSTALL_PATH" \
    --with-build-sysroot="$INSTALL_PATH" \
    --with-libiconv-prefix="$INSTALL_PATH" --with-libintl-prefix="$INSTALL_PATH" \
    --disable-rpath \
    --enable-install-libbfd \
    --disable-shared --enable-static \
    --enable-install-libiberty \
    --disable-nls --disable-werror && \
  make && \
  date --rfc-3339=seconds
}

if [[ $# -ne 0 ]]; then
  INSTALL_PATH="$1"
  echo "INSTALL_PATH := $INSTALL_PATH"
else
  INSTALL_PATH='/usr/local'
fi
_binutils_folder="binutils-2.31.1"

[[ -d binutils-build ]] && rm -rf binutils-build

_prepare_binutils 2>&1 | tee binutils-prepare.log && \
mkdir -p binutils-build && cd binutils-build && \
_build_binutils 2>&1 | tee ../binutils-build.log && \
make install && \
date --rfc-3339=seconds > ../binutils-check.log && \
make LDFLAGS="" check -k 2>&1 | tee ../binutils-check.log || true && \
date --rfc-3339=seconds >> ../binutils-check.log

# --enable-lto --enable-gold
# --enable-libssp
