#!/bin/bash
echo "Enter your USB path (e.g. /dev/sdb)"
USB=""
read USB
echo "usb:$USB"
sudo dd if=msmd-linux.iso of=$USB && sync
