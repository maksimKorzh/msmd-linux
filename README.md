[![IMAGE ALT TEXT HERE](https://raw.githubusercontent.com/maksimKorzh/msmd-linux/main/root/var/local/img/msmd-linux.png)](https://www.youtube.com/watch?v=EVTw4YqPdKA)

# About
Monkey See, Monkey Do LINUX is a didactic linux distribution serving
educational purposes. It offers a customly configured Linux Kernel,
Glibc, BusyBox, DHCP networking support and BIOS/UEFI boot.

# Download
<a href="https://github.com/maksimKorzh/msmd-linux/releases/tag/0.1">**MSMD Linux ISO:**</a>
 - Kernel 5.10.76
 - BusyBox 1.36.1
 - Glibc 2.38
 - ATH10K(Atheros), RTW88 Wifi firmware
 - wpa supplicant
 - vici (text editor)

# How to install MSMD Linux on USB or HDD assuming UEFI boot
1. Create two GPT partitions of types ESP (100mb) and Linux (all the rest)
2. Format first partition to FAT32 and second to EXT4 or EXT2
3. Run **hdd.sh** script, to update **init** script in initramfs
3. Mount both partitions
4. Copy /msmd-linux/EFI to ESP partition (this is bootloader)
5. Copy /msmd-root/root contents to Linux partition (this is root fs)
6. In ESP partition on a target drive in a EFI/ubuntu/grubcfg adjust the UUID to match your drive
7. In linux partition on a target drive in /boot/grub/grub.cfg adjust root to match your drive
8. Disable secure boot in your UEFI firmware settings, should be able to boot from your drive

    Essentially you need to end up with two GPT partitions partitions like<br>
    /dev/sda1 (ESP, fat32) and /dev/sda2 (Linux, ext4). Script **hdd.sh** allows you<br>
    to pick up custom block device names (e.g. /dev/nvme0n1p instead of /dev/sda1)<br>
    that would be used under initramfs init script to switch to the real root,<br>
    this is very important because if the target block device is not specified<br>
    properly switching from initramfs to actual root would fail.

# Build from sources
Use **build.sh** to create ISO from scratch<br>
Use **run.sh** to test in under QEMU<br>
Use **iso.sh** to burn ISO to USB flash drive<br>
If something doesn't work, which is very likely to occur, 
watch the tutorials below.

# Tutorials
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/DAXVgdpe7HE/0.jpg)](https://www.youtube.com/watch?v=DAXVgdpe7HE&list=PLLfIBXQeu3aZuc_0xTE2dY3juntHF5xJY&index=2)
