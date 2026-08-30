#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q etlegacy-git | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/etl.svg
export DESKTOP=/usr/share/applications/com.etlegacy.ETLegacy.$ARCH.desktop
export APPNAME="ET Legacy"
export STARTUPWMCLASS=etl.$ARCH
export USE_HOST_DRIVERS_EXPERIMENTAL=1

# Deploy dependencies
quick-sharun /usr/bin/etl.$ARCH /usr/lib/etlegacy/*

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --simple-test ./dist/*.AppImage
