# Android MITM Automation Script (Tested on MacBook)

This script automates the following manual processes:

1. **Install mitmproxy Certificate on Android**  
   Also supports configuring Burp Suite certificate using the same logic.

2. **Install Magisk Module: `AlwaysTrustUserCerts.zip`**  
   This module copies all user-installed certificates to system certificates, so all apps will trust them.  
   📦 [GitHub Repo – NVISOsecurity/MagiskTrustUserCerts](https://github.com/NVISOsecurity/MagiskTrustUserCerts)  
   The module is downloaded from this repository.

3. **Hook into Your App Using `objection`**

   ```bash
   objection -g com.freestylelibre3.app.us explore

Inside the objection console:

- android proxy set 192.168.1.224 8080
- android sslpinning disable

