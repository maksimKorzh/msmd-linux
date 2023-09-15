#!/bin/bash

################################################################################
#               _
#             ,//)         Build dynamic distro core from scratch
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
GLIBC_VER="glibc-2.38.tar.gz"
KERNEL_DIR=$(echo $KERNEL_VER | sed 's/\.tar\.xz//')
BUSYBOX_VER="busybox-1.36.1.tar.bz2"
GLIBC_DIR=$(echo $GLIBC_VER | sed 's/\.tar\.gz//')
BUSYBOX_DIR=$(echo $BUSYBOX_VER | sed 's/\.tar\.bz2//')

# Resolve dependencies
sudo apt-get install fakeroot build-essential ncurses-dev xz-utils libssl-dev bc flex libelf-dev bison

# Prepare working directory
rm -rf ../dst/iso ./build
rm -f ../dst/msmd-linux.iso
mkdir -p ../dst/iso/boot/grub
mkdir build
cd build

# Build kernel
wget "https://cdn.kernel.org/pub/linux/kernel/v5.x/$KERNEL_VER"
tar -xvf $KERNEL_VER
cd $KERNEL_DIR
make x86_64_defconfig -j $(nproc)
cp ../../../cfg/kernel.cfg .config
make bzImage -j $(nproc)
cd ..

# Build glibc
wget http://ftp.gnu.org/gnu/libc/$GLIBC_VER
tar -xvf $GLIBC_VER
cd $GLIBC_DIR
mkdir build
mkdir GLIBC
cd build
../configure --prefix=
make -j 2
make install DESTDIR=../GLIBC -j 2
cd ../..

# Build sysroot
mkdir -p sysroot/usr
cp -r $GLIBC_DIR/GLIBC/* sysroot
cp -r GLIBC/include/* sysroot/include/
cp -r GLIBC/lib/* sysroot/lib/
rsync -a /usr/include sysroot
ln -s ../include sysroot/usr/include
ln -s ../lib sysroot/usr/lib

# Build busybox
wget "https://busybox.net/downloads/busybox-1.36.1.tar.bz2"
tar -xvjf $BUSYBOX_VER
cd $BUSYBOX_DIR
make defconfig
sed -i "s|.*CONFIG_SYSROOT.*|CONFIG_SYSROOT=\"../sysroot\"|" .config
sed -i "s|.*CONFIG_EXTRA_CFLAGS.*|CONFIG_EXTRA_CFLAGS=\"-L../sysroot/lib\"|" .config
make -j $(nproc)
make CONFIG_PREFIX=$PWD/BUSYBOX install
cd ../..

# Build rootfs
mkdir root
cp -r sysroot/* ./root/
rsync -a $BUSYBOX_DIR/BUSYBOX/ root
cd root
rm linuxrc
sed -i 's/bash/sh/' ./bin/ldd
mkdir dev proc sys
cp ../../../ini/init .
cp ../../../ini/inittab ./etc/inittab
cp ../../../ini/logo.txt ./etc/logo.txt
cp ../../../ini/network.sh ./etc/network.sh
cp ../../../ini/shell.sh ./etc/shell.sh
cp ../../../ini/resolv.conf ./etc/resolv.conf
ln -s lib lib64
find . | cpio -o -H newc | gzip > ../root.cpio.gz
cd ../..

# Create ISO file
cp ./build/$KERNEL_DIR/arch/x86/boot/bzImage ../dst/iso/boot/bzImage
cp ./build/root.cpio.gz ../dst/iso/boot/root.cpio.gz
cp ../cfg/grub.cfg ../dst/iso/boot/grub/grub.cfg
grub-mkrescue -o ../dst/msmd-linux.iso ../dst/iso/
