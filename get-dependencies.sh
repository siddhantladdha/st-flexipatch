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
# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
if [ "${DEVEL_RELEASE-}" = 1 ]; then
    # weird but `imlib2` is needed instead of `libsixel` for st to use sixel patch.
    echo "Nightly release: Installing imlib2 for sixel patch..."
    echo "---------------------------------------------------------------"
    pacman -Syu --noconfirm imlib2
    echo "Applying sixel patch"
    echo "---------------------------------------------------------------"
    sed --in-place 's/#define SIXEL_PATCH 0/#define SIXEL_PATCH 1/g' patches.def.h
    make install st DESTDIR=./build PREFIX=/usr \
        X11INC=/usr/include/X11 X11LIB=/usr/lib/X11 \
        SIXEL_C="sixel.c sixel_hls.c" SIXEL_LIBS='`$(PKG_CONFIG) --libs imlib2`'
else
    make install st DESTDIR=./build PREFIX=/usr \
        X11INC=/usr/include/X11 X11LIB=/usr/lib/X11
fi
