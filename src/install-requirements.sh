check_package() {
  sudo apt-cache policy "$1" 2>/dev/null | grep -q 'Candidate'
}
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y automake curl git gnupg gcc g++ make pkg-config software-properties-common sudo zstd
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
curl -o /usr/share/keyrings/gh.gpg -sL https://cli.github.com/packages/githubcli-archive-keyring.gpg
chmod go+r /usr/share/keyrings/gh.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/gh.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/gh.list
for ppa in ppa:git-core/ppa ppa:ondrej/php; do
  LC_ALL=C.UTF-8 apt-add-repository "$ppa" -y
done
apt-get update
apt-get install -y git gh
if ! check_package php"$VERSION" || [ "${TS:?}" = "zts" ]; then
  curl -sSLO https://github.com/shivammathur/php-builder/releases/latest/download/install.sh
  chmod a+x ./install.sh
  ./install.sh local "$VERSION" "$TS"
else
  apt-get install -y --no-install-recommends php"$VERSION" php"$VERSION"-cli php"$VERSION"-xml php"$VERSION"-dev
fi

# Smoke Tests
php -v
php -m
