#! /bin/bash
systemctl stop monerod || exit 1

# Get the architecture
arch=$(uname -m)

# Determine the Monero release based on the architecture
case $arch in
    x86_64)
        release="linux64"  # 64-bit x86
        ;;
    i686 | i386)
        release="linux32"     # 32-bit x86
        ;;
    aarch32 | arm32 | armv7*)
        release="linuxarm7"   # 32-bit ARM
        ;;
    aarch64 | arm64 | armv8*)
        release="linuxarm8"   # 64-bit ARM
        ;;
    *)
        echo "Unsupported architecture: $arch"
        exit 1
        ;;
esac

# Print the determined release
echo "Detected architecture: $arch"
echo "Monero release to download: $release"

# Download the appropriate Monero release (example URL)
download_url="https://downloads.getmonero.org/${release}"

current_dir=$(pwd)
temp_dir=$(mktemp -d)
cd $temp_dir
wget $download_url || exit 1
tar -xjvf $release || exit 1
rm -v $release
cp -rv monero-*/monero* /usr/local/bin/ || exit 1
rm -rfv monero-*
cd $current_dir
rmdir -v $temp_dir

systemctl restart monerod || exit 1
