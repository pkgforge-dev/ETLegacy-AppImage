#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
#pacman -Syu --noconfirm

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

# Comment this out if you need an AUR package
make-aur-package enemy-territory
if [ "$ARCH" = "aarch64" ]; then
  PRE_BUILD_CMDS="sed -i 's/etlegacy\.x86_64\.service/etlegacy.aarch64.service/g' ./PKGBUILD" make-aur-package etlegacy-git
else
  make-aur-package etlegacy-git
fi

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
