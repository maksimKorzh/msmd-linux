#!/bin/bash

################################################################################
#               _
#             ,//)         Update MSMD Linux INITRAMFS image to run on HDD
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
ISO_DIR="$PWD/remaster/iso_src"

# Prepare directory
if [ -d $ISO_DIR/boot ]; then
  sudo umount $ISO_DIR
fi

# Optionally fetch files
if [ ! -d $ISO_DIR ]; then
  # Prepare working directories
  mkdir -p $ISO_DIR
  cd $REMASTER_DIR

  # Download & mount ISO
  wget https://github.com/maksimKorzh/msmd-linux/releases/download/0.1/$ISO
  cd $PWD_DIR
fi

# Mount ISO
sudo mount $REMASTER_DIR/$ISO $ISO_DIR -t iso9660 -o loop
cd $REMASTER_DIR

# Unpack rootfs
rm -rf root
mkdir root
cd root
gunzip -c $ISO_DIR/boot/root.cpio.gz | fakeroot -s $REMASTER_DIR/root.fakeroot cpio -i

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
find . | fakeroot -i $REMASTER_DIR/root.fakeroot cpio -o -H newc | gzip > $REMASTER_DIR/initramfs.cpio.gz

# Update initramfs
sudo cp $REMASTER_DIR/initramfs.cpio.gz $PWD_DIR/root/boot/root.cpio.gz

# Unmount ISO
if [ -d $ISO_DIR/boot ]; then
  sudo umount $ISO_DIR
fi
