#!/bin/bash

################################################################################
#               _
#             ,//)         Install packages
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

# Prepare working directory
rm -rf packages
mkdir packages
cd packages

# Download packages
git clone https://github.com/maksimKorzh/get       # statically linked alternative to 'wget'
git clone https://github.com/maksimKorzh/vici      # text editor

# Download & Compile Golang
wget "https://go.dev/dl/go1.21.0.src.tar.gz"
mkdir golang && cd golang
tar -xvf ../go1.21.0.src.tar.gz
cd go/src
echo -e "28\nc\nCGO_ENABLED=0\n.\n25\nwq" | ed -v make.bash
echo -e "25\nc\nGO_LDFLAGS='-extldflags \"-static\"'\n.\n25\nwq" | ed -v make.bash
./make.bash
cd ../../../

# Unpack rootfs
rm -rf root
mkdir root
cd root
gunzip -c ../../../dst/iso/boot/root.cpio.gz | fakeroot -s ../root.fakeroot cpio -i

# Make more folders
rm -rf home tmp
mkdir home tmp

# Install packages
cp ../get/src/get ./usr/bin/get
cp ../vici/src/vici ./usr/bin/vici
cp -r ../golang/go ./home/go

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
cp ../cfg/grub.cfg ../dst/iso/boot/grub/grub.cfg
grub-mkrescue -o ../dst/msmd-linux.iso ../dst/iso/
