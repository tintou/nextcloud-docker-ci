#!/bin/sh

# verbose and exit on error
set -xe

# import GPG keys
gpg --import /gpg/nextcloud-bot.public.asc
gpg --allow-secret-key-import --import /gpg/nextcloud-bot.asc
gpg --list-keys

# fetch git repo
git clone git@github.com:nextcloud/desktop.git
cd desktop

lupdate-qt5 src/gui/ src/cmd/ src/common/ src/crashreporter/ src/csync/ src/libsync/ -ts translations/client_en.ts

# push sources
tx push -s

# pull translations
tx pull -f -a --minimum-perc=25

# create git commit and push it
git add .
git commit -am "[tx-robot] updated from transifex" || true
git push origin master
echo "done"
