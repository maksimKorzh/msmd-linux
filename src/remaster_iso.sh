#!/bin/bash

################################################################################
#               _
#             ,//)         Remaster ISO image
#              ) /          __  __             _                ____
#             / /          |  \/  | ___  _ __ | | _____ _   _  / ___|  ___  ___
#       _,^^,/ /           | |\/| |/ _ \| '_ \| |/ / _ \ | | | \___ \ / _ \/ _ \
#      (C,OO<_/            | |  | | (_) | | | |   <  __/ |_| |  ___) |  __/  __/
#      _/\_,_)    _        |_|  |_|\___/|_| |_|_|\_\___|\__, | |____/ \___|\___|
#     / _    \  ,` )                                    |___/
#    / /"\    \/  ,_\         __  __             _                ____
# __(,/   >  e ) / (_\.oO    |  \/  | ___  _ __ | | _____ _   _  |  _ \  ___
# \_ /   (   -,_/    \_/     | |\/| |/ _ \| '_ \| |/ / _ \ | | | | | | |/ _ \
#   U     \_, _)             | |  | | (_) | | | |   <  __/ |_| | | |_| | (_) |
#           (  /             |_|  |_|\___/|_| |_|_|\_\___|\__, | |____/ \___/
#            >/                                           |___/
#           (.oO
#
################################################################################

# Exit on error
set -e

# Prepare directory
if [ -d iso/boot ]; then
  sudo umount iso
fi
rm -rf ../dst/iso
rm -rf iso
mkdir iso
mkdir -p ../dst/iso/boot/grub

# Download & mount ISO
ISO="msmd-linux-core-glibc.iso"
if [ ! -f $ISO ]; then
  wget https://github.com/maksimKorzh/msmd-linux/releases/download/1/$ISO
fi
sudo mount $ISO iso -t iso9660 -o loop

# Prepare working directory
rm -rf packages
mkdir packages
cd packages

# Download packages ~/msmd-linux/src/packages
#
# It's handy to download packages here
# but it's not obvious for you can copy
# files from any location
git clone https://github.com/maksimKorzh/vici
mkdir wpa_supplicant && cd wpa_supplicant
curl http://s.minos.io/archive/rlsd2/x86_64/wpa_supplicant.tar.gz > wpa_supplicant.tar.gz
tar -xvf wpa_supplicant.tar.gz && cd ..

# Unpack rootfs
rm -rf root
mkdir root
cd root
gunzip -c ../../iso/boot/root.cpio.gz | fakeroot -s ../root.fakeroot cpio -i

# Create new directories if needed
mkdir home tmp mnt
mkdir -p lib/firmware/rtw88

# Install packages ~/msmd-linux/src/packages/root
#
# You're now in root, copy any files
# to ./usr/bin or wherever within the
# root to include them into root.cpio.gz
cp ../vici/src/vici ./usr/bin/vici                            # install text editor
cp ../wpa_supplicant/bin/* ./usr/bin/                         # install wpa supplicant
cp ../../../fmw/rtw88/rtw8821c_fw.bin ./lib/firmware/rtw88    # install WiFi firmware for my laptop ;)

# Update init files
cp ../../../ini/init .
cp ../../../ini/inittab ./etc/inittab
cp ../../../ini/logo.txt ./etc/logo.txt
cp ../../../ini/network.sh ./etc/network.sh
cp ../../../ini/shell.sh ./etc/shell.sh
cp ../../../ini/wifi.sh ./usr/bin/wifi.sh

# Pack rootfs
find . | fakeroot -i ../root.fakeroot cpio -o -H newc | gzip > ../../../dst/iso/boot/root.cpio.gz

# Create ISO file
cd ../..
sudo cp ./iso/boot/bzImage ../dst/iso/boot/bzImage
cp ../cfg/grub.cfg ../dst/iso/boot/grub/grub.cfg
grub-mkrescue -o ../dst/msmd-linux.iso ../dst/iso/

# Unmount ISO
if [ -d iso/boot ]; then
  sudo umount iso
fi
