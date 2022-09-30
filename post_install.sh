#!/bin/sh

cd /usr/local
git clone https://github.com/FlareSolverr/FlareSolverr flaresolverr
cd flaresolverr

# Checkout version 2.2.9
git checkout c99101f74 

# Required to make puppeteer install on FreeBSD
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=/usr/local/bin/chrome

# get dependencies
npm install

# patch away puppeteer's arbitrary FreeBSD blocking 🙄
cd node_modules 

patch -p1 << EOF
diff -Naur node_modules/puppeteer/lib/cjs/puppeteer/node/BrowserFetcher.js node_modules_fixed/puppeteer/lib/cjs/puppeteer/node/BrowserFetcher.js
--- node_modules/puppeteer/lib/cjs/puppeteer/node/BrowserFetcher.js     2022-09-30 11:53:41.991795021 +0100
+++ node_modules_fixed/puppeteer/lib/cjs/puppeteer/node/BrowserFetcher.js       2022-09-30 11:53:10.867991454 +0100
@@ -180,6 +180,8 @@
             this._platform = 'linux';
         else if (platform === 'win32')
             this._platform = os.arch() === 'x64' ? 'win64' : 'win32';
+       else if (platform === 'freebsd')
+           this._platform = 'linux'
         else
             (0, assert_js_1.assert)(this._platform, 'Unsupported platform: ' + platform);
     }
@@ -505,4 +507,4 @@
     request.end();
     return request;
 }
-//# sourceMappingURL=BrowserFetcher.js.map
\ No newline at end of file
+//# sourceMappingURL=BrowserFetcher.js.map
diff -Naur node_modules/puppeteer/lib/cjs/puppeteer/node/BrowserFetcher.patch node_modules_fixed/puppeteer/lib/cjs/puppeteer/node/BrowserFetcher.patch
--- node_modules/puppeteer/lib/cjs/puppeteer/node/BrowserFetcher.patch  1970-01-01 01:00:00.000000000 +0100
+++ node_modules_fixed/puppeteer/lib/cjs/puppeteer/node/BrowserFetcher.patch    2022-09-30 11:52:26.293600027 +0100
@@ -0,0 +1,8 @@
+183,184d182
+<      else if (platform === 'freebsd')
+<          this._platform = 'linux'
+510c508
+< //# sourceMappingURL=BrowserFetcher.js.map
+---
+> //# sourceMappingURL=BrowserFetcher.js.map
+\ No newline at end of file
EOF

cd ..

# -- Set up service

cat << EOF
#
# Author: C. R. Zamana (czamana at gmail dot com)
#
# PROVIDE: flaresolverr
# REQUIRE: networking
# KEYWORD:

. /etc/rc.subr

name="flaresolverr"
rcvar="${name}_enable"
load_rc_config ${name}

: ${flaresolverr_enable:="NO"}

pidfile="/var/run/flaresolverr.pid"

start_precmd="flaresolverr_precmd"

PATH=$PATH:/usr/local/bin

flaresolverr_precmd() {
        cd /usr/local/share/flaresolverr
        export PUPPETEER_EXECUTABLE_PATH=/usr/local/bin/chrome
        export HOST=0.0.0.0
}

command="/usr/sbin/daemon"
command_args="-P ${pidfile} /usr/local/bin/npm start > /dev/null"

run_rc_command "$1"
EOF > /usr/local/etc/rc.d/flaresolverr

chmod +x /usr/local/etc/rc.d/flaresolverr

sysrc flaresolverr_enable=YES
service flaresolverr start
