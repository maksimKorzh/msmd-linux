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
rm -rf ../dts/iso
rm -rf iso
mkdir iso
mkdir -p ../dst/iso/boot/grub

# Download & mount ISO
if [ ! -f msmd-linux.iso ]; then
  wget "https://github.com/maksimKorzh/msmd-linux/releases/download/0.1/msmd-linux.iso"
fi
sudo mount msmd-linux.iso iso -t iso9660 -o loop

# Prepare working directory
rm -rf packages
mkdir packages
cd packages

# Download packages ~/msmd-linux/src/packages
#
# It's handy to download packages here
# but it's not obvious for you can copy
# files from any location

# Unpack rootfs
rm -rf root
mkdir root
cd root
gunzip -c ../../iso/boot/root.cpio.gz | fakeroot -s ../root.fakeroot cpio -i

# Install packages ~/msmd-linux/src/packages/root
#
# You're now in root, copy any files
# to ./usr/bin or wherever within the
# root to include them into root.cpio.gz

# Update init files
cp ../../../ini/init .
cp ../../../ini/inittab ./etc/inittab
cp ../../../ini/logo.txt ./etc/logo.txt
cp ../../../ini/network.sh ./etc/network.sh
cp ../../../ini/shell.sh ./etc/shell.sh

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
