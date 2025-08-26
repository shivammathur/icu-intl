ext_dir=$(php -i | grep "extension_dir => /" | sed -e "s|.*=> s*||")
icu_version=$(php -i | grep "ICU version =>" | sed -e "s|.*=> s*||")
[ "$icu_version" != "$ICU" ] && exit 1
cd "$ext_dir" || exit 1
[ "${TS:?}" = "zts" ] && suffix=-zts
arch="$(arch)"
[[ "$arch" = "aarch64" || "$arch" = "arm64" ]] && ARCH_SUFFIX='-arm64' || ARCH_SUFFIX=''
sudo cp intl.so "${WORKSPACE:?}"/php"$VERSION"-intl-"$ICU$suffix$ARCH_SUFFIX".so
cd "${WORKSPACE:?}" || exit 1
git config --global --add safe.directory "${WORKSPACE:?}"
if ! gh release view intl-$ICU; then
  gh release create "intl-$ICU" php"$VERSION"-intl-"$ICU$suffix$ARCH_SUFFIX".so -t "intl-$ICU" -n "intl-$ICU"
else
  gh release upload "intl-$ICU" php"$VERSION"-intl-"$ICU$suffix$ARCH_SUFFIX".so --clobber
fi
