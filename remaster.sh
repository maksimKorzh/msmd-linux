#!/bin/bash

################################################################################
#               _
#             ,//)         Remaster MSMD Linux ISO image
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
REMASTER_DIR="$PWD/remaster"
ROOT_DIR="$PWD/root"
ISO_SRC_DIR="$PWD/remaster/iso_src"
ISO_DST_DIR="$PWD/remaster/iso_dst"

# Prepare directory
if [ -d $ISO_SRC_DIR/boot ]; then
  sudo umount $ISO_SRC_DIR
fi

# Optionally fetch files
if [ ! -d $ISO_SRC_DIR ]; then
  # Prepare working directories
  mkdir -p $ISO_SRC_DIR
  mkdir -p $ISO_DST_DIR/boot/grub
  cd $REMASTER_DIR

  # Download & mount ISO
  wget https://github.com/maksimKorzh/msmd-linux/releases/download/0.1/$ISO

  # Download packages ~/msmd-linux/src/packages
  #
  # It's handy to download packages here
  # but it's not obvious for you can copy
  # files from any location
  cd $PWD_DIR
fi

# Mount ISO
sudo mount $REMASTER_DIR/$ISO $ISO_SRC_DIR -t iso9660 -o loop
cd $REMASTER_DIR

# Unpack rootfs
rm -rf root
mkdir root
cd root
gunzip -c $ISO_SRC_DIR/boot/root.cpio.gz | fakeroot -s $REMASTER_DIR/root.fakeroot cpio -i

# Update files
cp -r $PWD_DIR/root/* $REMASTER_DIR/root

# Pack rootfs
find . | fakeroot -i $REMASTER_DIR/root.fakeroot cpio -o -H newc | gzip > $REMASTER_DIR/root.cpio.gz

# Create ISO file
sudo cp $ISO_SRC_DIR/boot/bzImage $ISO_DST_DIR/boot/bzImage
sudo cp $REMASTER_DIR/root.cpio.gz $ISO_DST_DIR/boot/root.cpio.gz
cp $PWD_DIR/root/var/local/config/grub.cfg $ISO_DST_DIR/boot/grub/grub.cfg
grub-mkrescue -o $PWD_DIR/msmd-linux.iso $ISO_DST_DIR

# Unmount ISO
if [ -d $ISO_SRC_DIR/boot ]; then
  sudo umount $ISO_SRC_DIR
fi
