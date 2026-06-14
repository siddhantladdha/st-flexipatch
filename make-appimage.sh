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
# to avoid false triggers, since st is software rendering only.
export DEPLOY_OPENGL=0
export DEPLOY_VULKAN=0
# Setting runtime to always keep the mount point, should speed up startup.
export URUNTIME_PRELOAD=1
# Explicitly adding a path to xrdb binary is better way to ensure sharun packages it.
quick-sharun $DESTDIR$PREFIX/bin/st /usr/bin/xrdb
# Additional changes can be done in between here
# Fonts need to be manually copied over.
# copying only the monospace, ligature enabled nerd font.
mkdir --parents ./AppDir/usr/share/fonts/TTF
find /usr/share/fonts/TTF/ -maxdepth 1 -name "JetBrainsMonoNerdFontMono-*.ttf" -exec cp {} ./AppDir/usr/share/fonts/TTF/ \;

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
