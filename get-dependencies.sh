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

