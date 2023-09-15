#!/bin/bash

################################################################################
#               _
#             ,//)         Build distro core from scratch
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

# Versions
KERNEL_VER="linux-5.10.76.tar.xz"
BUSYBOX_VER="busybox-1.36.1.tar.bz2"
KERNEL_DIR=$(echo $KERNEL_VER | sed 's/\.tar\.xz//')
BUSYBOX_DIR=$(echo $BUSYBOX_VER | sed 's/\.tar\.bz2//')

# Resolve dependencies
sudo apt-get install fakeroot build-essential ncurses-dev xz-utils libssl-dev bc flex libelf-dev bison

# Prepare working directory
rm -rf ../dst/iso ./build
rm -f ../dst/msmd-linux.iso
mkdir -p ../dst/iso/boot/grub
mkdir build

# Build kernel
cd build
wget "https://cdn.kernel.org/pub/linux/kernel/v5.x/$KERNEL_VER"
tar -xvf $KERNEL_VER
cd $KERNEL_DIR
make x86_64_defconfig -j $(nproc)
cp ../../../cfg/kernel.cfg .config
make bzImage -j $(nproc)
cd ../..

# Build busybox
cd build
wget "https://busybox.net/downloads/busybox-1.36.1.tar.bz2"
tar -xvjf $BUSYBOX_VER
cd $BUSYBOX_DIR
make defconfig
cp ../../../cfg/busybox.cfg .config
make -j $(nproc)
make CONFIG_PREFIX=$PWD/BUSYBOX install
cd ../..

# Build root file system
rm -rf ./build/root
cp -r ./build/$BUSYBOX_DIR/BUSYBOX ./build/root
cd ./build/root
rm linuxrc
mkdir dev proc sys etc
cp ../../../ini/init .
cp ../../../ini/inittab ./etc/inittab
cp ../../../ini/logo.txt ./etc/logo.txt
cp ../../../ini/network.sh ./etc/network.sh
find . | cpio -o -H newc | gzip > ../root.cpio.gz
cd ../..

# Create ISO file
cp ./build/$KERNEL_DIR/arch/x86/boot/bzImage ../dst/iso/boot/bzImage
cp ./build/root.cpio.gz ../dst/iso/boot/root.cpio.gz
cp ../cfg/grub.cfg ../dst/iso/boot/grub/grub.cfg
grub-mkrescue -o ../dst/msmd-linux.iso ../dst/iso/
