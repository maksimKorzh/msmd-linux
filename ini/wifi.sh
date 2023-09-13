#!/bin/sh

# Change to your SSID and WPA password
SSID="home_2.4"
PASS="Admin_1234"

# Create WPA supplicant configuration file
wpa_passphrase $SSID $PASS > /home/wifi.conf

# Connect to SSID
wpa_supplicant -B -D nl80211 -i wlan0 -c /home/wifi.conf
sleep 5

# Receive IP address
udhcpc -b -i wlan0 -s /etc/network.sh
