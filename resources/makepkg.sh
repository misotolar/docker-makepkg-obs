#!/bin/bash

set -e

sudo pacman -Syu --noconfirm

if [[ -z "$BUILD_PATH" ]]; then
    BUILD_PATH=$(pwd)
fi

cp -r "$BUILD_PATH" /tmp/build

if [[ -d /tmp/build/keys/pgp ]]; then
    echo '==> Importing PGP keys...'
    gpg --import /tmp/build/keys/pgp/*.asc
else
    source PKGBUILD
    if [[ ${#validpgpkeys[@]} > 0 ]]; then
        echo '==> Fetching PGP keys...'
        gpg --recv-keys ${validpgpkeys[@]}
    fi
fi

env -C /tmp/build makepkg -o --syncdeps --noconfirm

echo "user=$OBS_USERNAME" >> /home/build/.config/osc/oscrc
echo "pass=$OBS_PASSWORD" >> /home/build/.config/osc/oscrc

PACKAGE_PATH="/home/build/$OBS_PROJECT/$OBS_PACKAGE"
env -C /home/build osc checkout "$OBS_PROJECT" && cd $PACKAGE_PATH
rsync -avu --delete --exclude=".*" --exclude="*/" /tmp/build/ .

osc addremove
if [[ ! -z "$CI_COMMIT_MESSAGE" ]]; then
    osc commit -m "$CI_COMMIT_MESSAGE"
else
    osc commit -n
fi
