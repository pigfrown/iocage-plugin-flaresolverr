#!/bin/sh

cd /usr/local/share || exit
git clone https://github.com/FlareSolverr/FlareSolverr flaresolverr
cd flaresolverr || exit

# Checkout version
git checkout v3.2.1

pip install -r requirements.txt

patch -V none -p1 << EOF
diff --git a/src/undetected_chromedriver/patcher.py b/src/undetected_chromedriver/patcher.py
index 24da802..159ae8d 100644
--- a/src/undetected_chromedriver/patcher.py
+++ b/src/undetected_chromedriver/patcher.py
@@ -17,7 +17,7 @@ import zipfile

 logger = logging.getLogger(__name__)

-IS_POSIX = sys.platform.startswith(("darwin", "cygwin", "linux", "linux2"))
+IS_POSIX = sys.platform.startswith(("darwin", "cygwin", "linux", "linux2", "freebsd"))


 class Patcher(object):
diff --git a/src/utils.py b/src/utils.py
index 3f06f5a..b72f834 100644
--- a/src/utils.py
+++ b/src/utils.py
@@ -12,7 +12,7 @@ CHROME_EXE_PATH = None
 CHROME_MAJOR_VERSION = None
 USER_AGENT = None
 XVFB_DISPLAY = None
-PATCHED_DRIVER_PATH = None
+PATCHED_DRIVER_PATH = "/usr/local/bin/chromedriver"


 def get_config_log_html() -> bool:
EOF

sysrc flaresolverr_enable=YES
service flaresolverr start
