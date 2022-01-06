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

if [[ $# -ne 0 ]]; then
  INSTALL_PATH="$1"
else
  INSTALL_PATH="`pwd`/local"
fi
_binutils_folder="binutils-2.32"

date --rfc-3339=seconds > binutils-prepare.log && \
cd ${_binutils_folder} && _patch_binutils | tee ../binutils-prepare.log && cd .. && \
date --rfc-3339=seconds >> ../binutils-prepare.log
mkdir -p binutils-build && cd binutils-build && \
date --rfc-3339=seconds > ../binutils-build.log && \
../${_binutils_folder}/configure --prefix="$INSTALL_PATH" \
  --with-build-sysroot="$INSTALL_PATH" \
  --with-libiconv-prefix="$INSTALL_PATH" --with-libintl-prefix="$INSTALL_PATH" \
  --enable-nls --disable-werror 2>&1 | tee ../binutils-build.log && \
make 2>&1 | tee ../binutils-build.log && \
date --rfc-3339=seconds >> ../binutils-build.log && \
make install && \
make check -k
