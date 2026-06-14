#!/bin/sh

set -eu

ARCH=$(uname -m)
#VERSION=$(pacman -Q PACKAGENAME | awk '{print $2; exit}') # example command to get version of application here
VERSION=$(sed -n 's/^VERSION = //p' ./config.mk)
# VERSION=0.9.3
export ARCH VERSION

DESTDIR=./build
PREFIX=/usr
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=./st.png
export DESKTOP=$DESTDIR$PREFIX/share/applications/st.desktop
# Deploy dependencies
# Deploy fonts. Hoping right now that this will automatically make
# sharun and anything else look for this before doing anything.
# testing pending.
export DEPLOY_DATADIR=1
# quick-sharun $DESTDIR$PREFIX/bin/st
# Explicitly adding a path to xrdb binary is better way to ensure sharun packages it.
quick-sharun $DESTDIR$PREFIX/bin/st /usr/bin/xrdb
# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
