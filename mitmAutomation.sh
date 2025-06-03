#!/bin/bash

echo "[+] Detecting Local IP..."
IP=$(ipconfig getifaddr en0)
echo "[+] Mac Local IP: $IP"

echo "[+] Installing MITMProxy if not installed..."
if ! command -v mitmproxy &> /dev/null; then
    brew install mitmproxy
fi

####################################################################################################
############### INSTALLING MITM USER CERTS TO ANDROID ############################

echo "[+] Installing MITMProxy certificate on Android..."

echo "🔍 Checking if adb is installed..."
if ! command -v adb &> /dev/null; then
    echo "❌ adb not found! Install it using: brew install android-platform-tools"
    exit 1
fi

echo "🔌 Connecting to Android device via ADB..."
adb devices | grep "device$" > /dev/null
if [ $? -ne 0 ]; then
    echo "❌ No Android device found. Make sure USB debugging is enabled!"
    exit 1
fi

# Push certificate to /sdcard/Download/
echo "📂 Pushing mitmproxy-ca-cert.pem to /sdcard/..."
adb push "mitmproxy-ca-cert.pem" "/sdcard/"

# Ensure root access
echo "🔑 Checking for root access..."
adb shell su -c "echo Root access granted" || { echo "❌ Root access denied. Exiting."; exit 1; }

# Move the certificate to the user CA store
echo "📌 Moving certificate to /data/misc/user/0/cacerts-added/..."
adb shell su -c "mkdir -p /data/misc/user/0/cacerts-added"
adb shell su -c "cp /sdcard/mitmproxy-ca-cert.pem /data/misc/user/0/cacerts-added/"

# Check if the file actually exists
adb shell su -c "ls -l /data/misc/user/0/cacerts-added/mitmproxy-ca-cert.pem" || { echo "❌ Certificate copy failed!"; exit 1; }

# Set correct permissions
echo "🔑 Setting permissions..."
adb shell su -c "chmod 644 /data/misc/user/0/cacerts-added/mitmproxy-ca-cert.pem"
adb shell su -c "chown system:system /data/misc/user/0/cacerts-added/mitmproxy-ca-cert.pem"

adb shell su -c "ls -l /data/misc/user/0/cacerts-added/mitmproxy-ca-cert.pem" || { echo "❌ Certificate copy failed!"; exit 1; }

####################################################################################################
############### INSTALLING MAGISK MODULE FOR COPYING USER CERTS TO SYSTEM ###########################

adb push AlwaysTrustUserCerts.zip /storage/emulated/0/Download/
adb shell su -c "magisk --install-module /storage/emulated/0/Download/AlwaysTrustUserCerts.zip"

############### REBOOTING FOR THE CHANGES TO TAKE EFFECT ############################################
adb reboot


echo "[+] Starting MITMProxy ..."
sudo mitmdump --listen-host 0.0.0.0 --listen-port 8080 
