#!/bin/sh

cd /usr/local/share/flaresolverr || exit
git fetch --all
VERSION=$(git tag --sort=v:refname | tail -1)
git checkout "$VERSION"
pip install -U -r requirements.txt
patch -V none -p1 << EOF
diff --git a/src/undetected_chromedriver/patcher.py b/src/undetected_chromedriver/patcher.py
index c20ead8..4c410e4 100644
--- a/src/undetected_chromedriver/patcher.py
+++ b/src/undetected_chromedriver/patcher.py
@@ -18,7 +18,7 @@ import zipfile

 logger = logging.getLogger(__name__)

-IS_POSIX = sys.platform.startswith(("darwin", "cygwin", "linux", "linux2"))
+IS_POSIX = sys.platform.startswith(("darwin", "cygwin", "linux", "linux2", "freebsd"))


 class Patcher(object):
diff --git a/src/utils.py b/src/utils.py
index ceff7ec..dd3aba5 100644
--- a/src/utils.py
+++ b/src/utils.py
@@ -11,7 +11,7 @@ FLARESOLVERR_VERSION = None
 CHROME_MAJOR_VERSION = None
 USER_AGENT = None
 XVFB_DISPLAY = None
-PATCHED_DRIVER_PATH = None
+PATCHED_DRIVER_PATH = "/usr/local/bin/chromedriver"


 def get_config_log_html() -> bool:
EOF
service flaresolverr start
