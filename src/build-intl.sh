ext_dir=$(php -i | grep "extension_dir => /" | sed -e "s|.*=> s*||")
scan_dir=$(php --ini | grep additional | sed -e "s|.*: s*||")
pecl_file="$scan_dir"/99-pecl.ini
get_tag() {
  if [ "${VERSION:?}" = "8.1" ]; then
    echo "master"
  else
    echo "php-$(php -v | head -n 1 | cut -f 2 -d ' ' | cut -f 1 -d '-')"
  fi
}
get_php() {
  curl -sL "https://github.com/php/php-src/archive/$tag.tar.gz" | tar xzf - -C "/tmp"
}
check_extension() {
  extension=$1
  if [ "$extension" != "mysql" ]; then
    php -m | grep -i -q -w "$extension"
  else
    php -m | grep -i -q "$extension"
  fi
}
enable_extension() {
  if ! check_extension "$1" && [ -e "$ext_dir/$1.so" ]; then
    echo "$2=$1.so" | sudo tee -a "$pecl_file"
  fi
}
install_icu() {
  curl -o /tmp/icu.tar.zst -sL https://github.com/"${REPO:?}"/releases/download/icu4c/icu4c-"$ICU".tar.zst
  sudo tar -I zstd -xf /tmp/icu.tar.zst -C /usr/local
  sudo cp -r /usr/local/icu/* /usr/
  sudo cp -r /usr/local/icu/lib/* /usr/lib/x86_64-linux-gnu/
}
install_intl() {
  tag=$(get_tag)
  get_php
  (
    cd "/tmp/php-src-$tag/ext/intl" || exit 1
    phpize && sudo ./configure --with-php-config="$(command -v php-config)" --enable-intl
    echo "#define FALSE 0" >> config.h
    echo "#define TRUE 1" >> config.h
    make CXXFLAGS="-O2 -std=c++11 -DU_USING_ICU_NAMESPACE=1 -DTRUE=1 -DFALSE=0 $CXXFLAGS"
    sudo cp ./modules/* "$ext_dir/"
    enable_extension intl extension
  )
}

install_icu
install_intl
