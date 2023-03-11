#!/bin/sh

service flaresolverr stop
cd /usr/local/share/flaresolverr || exit
git reset --hard @
