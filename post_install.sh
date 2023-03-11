#!/bin/sh

cd /usr/local/share
git clone https://github.com/FlareSolverr/FlareSolverr flaresolverr
cd flaresolverr

# Checkout version
git checkout v3.0.2

pip install -r requirements.txt

patch -p1 << EOF
diff --git a/src/undetected_chromedriver/_compat.py b/src/undetected_chromedriver/_compat.py
index 6b2f28a..ad8bccc 100644
--- a/src/undetected_chromedriver/_compat.py
+++ b/src/undetected_chromedriver/_compat.py
@@ -155,6 +155,8 @@ class ChromeDriverManager(object):
         if _platform in ("linux",):
             _platform += "64"
             exe_name = exe_name.format("")
+        if _platform in ("freebsd",):
+            exe_name = exe_name.format("")
         if _platform in ("darwin",):
             _platform = "mac64"
             exe_name = exe_name.format("")
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

sysrc flaresolverr_enable=YES
service flaresolverr start
