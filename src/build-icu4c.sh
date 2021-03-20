curl -o /tmp/icu.tgz -sL https://github.com/unicode-org/icu/releases/download/release-"${ICU/./-}"/icu4c-"${ICU/./_}"-src.tgz
tar -zxf /tmp/icu.tgz -C /tmp
(
  cd /tmp/icu/source || exit 1
  sudo mkdir /usr/local/icu
  sudo ln -sf /usr/include/locale.h /usr/include/xlocale.h || true
  ./configure --prefix=/usr/local/icu
  make -j"$(nproc)"
  sudo make install
)
