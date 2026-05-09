#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm libxft harfbuzz base-devel libxcursor ttf-jetbrains-mono-nerd xorg-xrdb
# echo "Installing debloated packages..."
# echo "---------------------------------------------------------------"
# get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
make install st DESTDIR=./build PREFIX=/usr X11INC=/usr/include/X11 X11LIB=/usr/lib/X11
# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
