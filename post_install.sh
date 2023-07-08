#!/bin/sh

cd /usr/local/share || exit
git clone https://github.com/FlareSolverr/FlareSolverr flaresolverr
cd flaresolverr || exit

# Checkout version
git checkout v3.2.1

pip install -r requirements.txt

sed -i -e 's/^\(IS_POSIX =.*\)))/\1, "freebsd"))/' src/undetected_chromedriver/patcher.py
sed -i -e 's/^\(PATCHED_DRIVER_PATH =\).*/\1 "\/usr\/local\/bin\/chromedriver"/' src/utils.py

sysrc flaresolverr_enable=YES
service flaresolverr start
