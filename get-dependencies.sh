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
    sdl2-compat

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

echo "Building ETLegacy..."
echo "---------------------------------------------------------------"
REPO="https://github.com/etlegacy/etlegacy"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive --depth 1 "$REPO" ./etlegacy
echo "$VERSION" > ~/version

wget https://mirror.etlegacy.com/et260b.x86_keygen_V03.run.zip
bsdtar -xf ./et260b.x86_keygen_V03.run.zip
sh ./et260b.x86_keygen_V03.run --noexec --nox11 --target enemy-territory
rm -rf ./et260b.x86_keygen_V03.run.zip ./et260b.x86_keygen_V03.run './readme first !!! et260b'
mkdir -p /usr/lib/etlegacy/etmain
mv -v ./enemy-territory/etmain/pak0.pk3 ./enemy-territory/etmain/pak1.pk3 ./enemy-territory/etmain/pak2.pk3 /usr/lib/etlegacy/etmain/
rm -rf ./enemy-territory

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
