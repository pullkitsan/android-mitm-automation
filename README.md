# Android MITM Automation Script (Tested on MacBook)

NOTE : THIS WORKS ONLY FOR ANDROID ROOTED WITH MAGISK and for Android <=13

This script automates the following manual processes:

1. **Install mitmproxy Certificate on Android**  
   Also supports configuring Burp Suite certificate using the same logic.

2. **Install Magisk Module: `AlwaysTrustUserCerts.zip`**  
   This module copies all user-installed certificates to system certificates, so all apps will trust them.  
   📦 [GitHub Repo – NVISOsecurity/MagiskTrustUserCerts](https://github.com/NVISOsecurity/MagiskTrustUserCerts)  
   The module is downloaded from this repository.

3. **Hook into Your App Using `objection`**

   ```bash
   objection -g <APP_PACKAGE_NAME> explore

Inside the objection console:

- android proxy set <MAC_IP_ADDR> 8080
- android sslpinning disable

