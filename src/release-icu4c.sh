arch="$(arch)"
[[ "$arch" = "aarch64" || "$arch" = "arm64" ]] && ARCH_SUFFIX='-arm64' || ARCH_SUFFIX=''
sudo chmod -R 777 /usr/local
cd /usr/local || exit 1
sudo tar cf - icu | zstd -22 -T0 --ultra > "${WORKSPACE:?}"/icu4c-"$ICU$ARCH_SUFFIX".tar.zst
cd "${WORKSPACE:?}" || exit 1
git config --global --add safe.directory "${WORKSPACE:?}"
if ! gh release view icu4c; then
  gh release create "icu4c" icu4c-"$ICU$ARCH_SUFFIX".tar.zst -t "icu4c" -n "icu4c"
else
  gh release upload "icu4c" icu4c-"$ICU$ARCH_SUFFIX".tar.zst --clobber
fi
