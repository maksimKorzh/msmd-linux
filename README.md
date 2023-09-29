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

# Networking
Run **ethernet** command to connect to the ethernet network, this might
be the case if you're running a demo ISO under QEMU. If you want to connect
to WiFi run **wifi** after manually adjusting SSID and password under **/bin/wifi.sh**.

# How to install MSMD Linux on HDD (UEFI boot)
1. Download msmd-linux repository
2. Run **install.sh** command to generate installation ISO
3. Burn installation ISO to USB flash drive using **burn-iso.sh**
4. Boot from your USB flash drive
5. Connect to network by running **ethernet** or **wifi** (don't forget tochange SSID/PASS)
6. Run command **install_packages**, this would install fdisk, mkfs.ext4 and more
7. Create two GPT partitions of types ESP (100mb) and Linux (all the rest) on HDD
8. Format first partition to FAT32 and second to EXT4
9. Mount both partitions
10. Copy /msmd-linux/EFI to ESP partition (this is bootloader)
11. Copy /msmd-root/root contents to Linux partition (this is root fs)
12. In ESP partition on a target drive in a EFI/ubuntu/grub.cfg adjust the UUID to match your drive
13. In linux partition on a target drive in /boot/grub/grub.cfg adjust the UUID to match your drive
14. Disable secure boot in your UEFI firmware settings, you should be able to boot from your drive

Essentially you need to end up with two GPT partitions partitions like<br>
/dev/sda1 (ESP, fat32) and /dev/sda2 (Linux, ext4). Script **install.sh** allows you<br>
to pick up custom block device names (e.g. /dev/nvme0n1p instead of /dev/sda1)<br>
that would be used under initramfs init script to switch to the real root,<br>
this is very important because if the target block device is not specified<br>
properly switching from initramfs to actual root would fail.

# Package manager
I've been playing around with tce-load from Tiny Core Linux and generally it's
compatible if rootfs is adjusted accordingly, however it fails to save changes
after reboot because tcl packages reside under /tmp and get erased every reboot.
So I've created a custom package installer with a persistent storage of packages.
It's called **dipi**. It would get installed after running command **install_packages**.
<br>
Usage: **~$ dipi vim**<br>
<br>
If you're unsure whether package exists you can run the following command:<br>
**wget -O- http://tinycorelinux.net/14.x/x86_64/tcz | grep your_keyword**

# Build from sources
Use **build.sh** to create ISO from scratch<br>
If something doesn't work, which is very likely to occur, 
watch the tutorials below.

# Tutorials
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/DAXVgdpe7HE/0.jpg)](https://www.youtube.com/watch?v=DAXVgdpe7HE&list=PLLfIBXQeu3aZuc_0xTE2dY3juntHF5xJY&index=2)
