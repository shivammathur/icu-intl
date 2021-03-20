export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y automake curl gnupg make pkg-config software-properties-common sudo zstd
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
for ppa in ppa:git-core/ppa ppa:ondrej/php https://cli.github.com/packages; do
  LC_ALL=C.UTF-8 apt-add-repository "$ppa" -y
done
apt-get install -y git gh php"$VERSION" php"$VERSION"-xml php"$VERSION"-dev