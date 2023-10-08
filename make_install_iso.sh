#!/bin/bash

################################################################################
#               _
#             ,//)         Create MSMD Linux Installation ISO
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

# Constants
ISO="msmd-linux.iso"
PWD_DIR="$(pwd)"
INSTALL_DIR="$PWD/install"
ISO_DIR="$PWD/install/iso"
INSTALL_ISO="$PWD/install_iso"

# Prepare directory
if [ -d $ISO_DIR/boot ]; then
  sudo umount $ISO_DIR
fi

# Optionally fetch files
if [ ! -d $ISO_DIR ]; then
  # Prepare working directories
  mkdir -p $ISO_DIR
  cd $INSTALL_DIR

  # Download & mount ISO
  wget https://github.com/maksimKorzh/msmd-linux/releases/download/0.1/$ISO
  wget https://github.com/maksimKorzh/msmd-linux/releases/download/0.1/EFI.zip
  unzip EFI.zip
  cd $PWD_DIR
fi

# Mount ISO
sudo mount $INSTALL_DIR/$ISO $ISO_DIR -t iso9660 -o loop
cd $INSTALL_DIR

# Unpack rootfs
rm -rf root
mkdir root
cd root
gunzip -c $ISO_DIR/boot/root.cpio.gz | fakeroot -s $INSTALL_DIR/root.fakeroot cpio -i

# Install root
sudo rm -rf $INSTALL_ISO
mkdir -p $INSTALL_ISO/root/boot/grub
cp -r * $INSTALL_ISO/root/
cp $ISO_DIR/boot/bzImage $INSTALL_ISO/root/boot/bzImage
cp -r $ISO_DIR/boot/grub/* $INSTALL_ISO/root/boot/grub/

# Install EFI
sudo cp -r $INSTALL_DIR/EFI $INSTALL_ISO/EFI

# Update initramfs init
echo "Enter device path where rootfs resides: (e.g. /dev/sda2)"
DEV=""
read DEV
echo "Enter device boot delay: (e.g. 5 to wait for 5 secs until USB drive is connected)"
DELAY=""
read DELAY
echo "#!/bin/sh" > init
echo "dmesg -n 1" >> init
echo "clear" >> init
echo "mkdir -p dev" >> init
echo "mkdir -p proc" >> init
echo "mkdir -p sys" >> init
echo "mount -t devtmpfs none /dev" >> init
echo "mount -t proc none /proc" >> init
echo "mount -t sysfs none /sys" >> init
echo "cat /etc/logo.txt" >> init
echo "echo switching to rootfs at $DEV" >> init
echo "sleep $DELAY" >> init
echo "mkdir mnt" >> init
echo "mount $DEV /mnt" >> init
echo "exec switch_root /mnt /init" >> init
chmod a+x init
find . | fakeroot -i $INSTALL_DIR/root.fakeroot cpio -o -H newc | gzip > $INSTALL_DIR/initramfs.cpio.gz

# Update initramfs
sudo cp $INSTALL_DIR/initramfs.cpio.gz $INSTALL_ISO/root/boot/root.cpio.gz

# Create install ISO
mkdir -p $INSTALL_ISO/boot/grub
sudo cp $ISO_DIR/boot/root.cpio.gz $INSTALL_ISO/boot/root.cpio.gz
sudo cp $ISO_DIR/boot/bzImage $INSTALL_ISO/boot/bzImage
sudo cp $ISO_DIR/boot/grub/grub.cfg $INSTALL_ISO/boot/grub/grub.cfg
grub-mkrescue -o $PWD_DIR/msmd-linux.iso $INSTALL_ISO

# Unmount ISO
if [ -d $ISO_DIR/boot ]; then
  sudo umount $ISO_DIR
fi

# Clean up
sudo rm -rf $INSTALL_DIR
sudo rm -rf $INSTALL_ISO
