ext_dir=$(php -i | grep "extension_dir => /" | sed -e "s|.*=> s*||")
icu_version=$(php -i | grep "ICU version =>" | sed -e "s|.*=> s*||")
[ "$icu_version" != "$ICU" ] && exit 1
cd "$ext_dir" || exit 1
sudo cp intl.so "${WORKSPACE:?}"/php"$VERSION"-intl-"$ICU".so
cd "${WORKSPACE:?}" || exit 1
git config --global --add safe.directory "${WORKSPACE:?}"
if ! gh release view intl; then
  gh release create "intl" php"$VERSION"-intl-"$ICU".so -t "intl" -n "intl"
else
  gh release upload "intl" php"$VERSION"-intl-"$ICU".so --clobber
fi
