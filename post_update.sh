#!/bin/sh

cd /usr/local/share/flaresolverr || exit
git fetch --all
VERSION=$(git tag --sort=v:refname | tail -1)
git checkout "$VERSION"
pip install -r requirements.txt
service flaresolverr start
