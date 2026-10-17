#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cjson         \
    cmake         \
    glew          \
    libjpeg-turbo \
    libtheora     \
    lua54         \
    minizip       \
    openal        \
    sqlite        \
    sdl2-compat

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

# Comment this out if you need an AUR package
#make-aur-package enemy-territory
#if [ "$ARCH" = "aarch64" ]; then
#  PRE_BUILD_CMDS="sed -i 's/etlegacy\.x86_64\.service/etlegacy.aarch64.service/g' ./PKGBUILD" make-aur-package etlegacy-git
#else
#  make-aur-package etlegacy-git
#fi
echo "Building ETLegacy..."
echo "---------------------------------------------------------------"
REPO="https://github.com/etlegacy/etlegacy"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive --depth 1 "$REPO" ./etlegacy
echo "$VERSION" > ~/version

cmake -S ./etlegacy -B build \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_INSTALL_PREFIX=/usr \
    -D INSTALL_DEFAULT_BASEDIR=/usr/lib/etlegacy \
    -D INSTALL_DEFAULT_BINDIR=bin \
    -D INSTALL_DEFAULT_MODDIR=lib/etlegacy \
    -D INSTALL_DEFAULT_SHAREDIR=share \
    -D CMAKE_LIBRARY_PATH=/usr/lib \
    -D CMAKE_INCLUDE_PATH=/usr/include \
    -D CROSS_COMPILE32=0 \
    -D BUNDLED_LIBS=0 \
    -D FEATURE_AUTOUPDATE=0 \
    -D FEATURE_OMNIBOT=1 \
    -D INSTALL_OMNIBOT=0
cmake --build build -j$(nproc)
cmake --install build

ln -s /usr/share/enemy-territory/etmain/*.pk3 /usr/lib/etlegacy/etmain/

mkdir -p /etc/xdg/etlegacy/etmain
mkdir -p /usr/lib/systemd/system
mv -v ./etlegacy/misc/etlegacy.conf /etc/xdg/etlegacy/
mv -v ./etlegacy/misc/etlegacy.${ARCH}.service /usr/lib/systemd/system/

mv -v /usr/lib/etlegacy/etmain/*.cfg /etc/xdg/etlegacy/etmain/
ln -s /etc/xdg/etlegacy/etmain/{etl_server,legacy,{campaign,lms,mapvote,objective}cycle}.cfg /usr/lib/etlegacy/etmain/

mkdir -p /var/lib/etlegacy-server
ln -s /etc/xdg/etlegacy/etmain /var/lib/etlegacy-server/
