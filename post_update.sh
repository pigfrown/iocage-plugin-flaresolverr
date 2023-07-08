#!/bin/sh

cd /usr/local/share/flaresolverr || exit
git fetch --all
VERSION=$(git tag --sort=v:refname | tail -1)
git checkout "$VERSION"
pip install -U -r requirements.txt
sed -i '' -e 's/^\(IS_POSIX =.*\)))/\1, "freebsd"))/' src/undetected_chromedriver/patcher.py
sed -i '' -e 's/^\(PATCHED_DRIVER_PATH =\).*/\1 "\/usr\/local\/bin\/chromedriver"/' src/utils.py
service flaresolverr start
