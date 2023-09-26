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

# Networking
If you're running an ISO either on QEMU or real hardware
ethernet connection should be established automatically
if available. If you want WiFi connection, run **wifi.sh**
after manually adjusting SSID and password under **/bin/wifi.sh**.
If you've installed MSMD Linux on USB/HDD you'll need to manually
run either **ethernet.sh** or **wifi.sh** to connect to the network.

# How to install MSMD Linux on USB/HDD (UEFI boot)
1. Create two GPT partitions of types ESP (100mb) and Linux (all the rest)
2. Format first partition to FAT32 and second to EXT4 or EXT2
3. Run **hdd.sh** script, to update **init** script in initramfs
3. Mount both partitions
4. Copy /msmd-linux/EFI to ESP partition (this is bootloader)
5. Copy /msmd-root/root contents to Linux partition (this is root fs)
6. In ESP partition on a target drive in a EFI/ubuntu/grub.cfg adjust the UUID to match your drive
7. In linux partition on a target drive in /boot/grub/grub.cfg adjust root to match your drive
8. Disable secure boot in your UEFI firmware settings, you should be able to boot from your drive

Essentially you need to end up with two GPT partitions partitions like<br>
/dev/sda1 (ESP, fat32) and /dev/sda2 (Linux, ext4). Script **hdd.sh** allows you<br>
to pick up custom block device names (e.g. /dev/nvme0n1p instead of /dev/sda1)<br>
that would be used under initramfs init script to switch to the real root,<br>
this is very important because if the target block device is not specified<br>
properly switching from initramfs to actual root would fail.

# Package manager
I've been playing around with tce-load from Tiny Core Linux and generally it's
compatible if rootfs is adjusted accordingly, however it fails to save changes
after reboot because tcl packages reside under /tmp and get erased every reboot.
So I've created a custom package installer with a persistent storage of packages.
It's called **pi** and available under **root/bin/** folder. If you're using
MSMD Linux ISO image you can download this repo with command:<br>
**wget https://github.com/maksimKorzh/msmd-linux/archive/refs/heads/master.zip**<br>
and then manually install **pi** to **\bin** folder just to tinker with it. If you're
installing MSMD Linux onto HDD or USB **pi** would be there by default.<br>
<br>
Usage: **~$ pi vim**<br>
<br>
If you're unsure whether package exists you can run the following command:<br>
**wget -O- http://tinycorelinux.net/14.x/x86_64/tcz | grep your_keyword**

# Customizing rootfs
Earlier I've been providing scripts to remaster ISO but that resulted in mess,
so eventually I switched to **install to USB/HDD** model. With this approach
once you've installed MSMD Linux you're free to alter rootfs the way you want,
e.g. add custom WiFi firmare (you'd probably need to recompile the kernel in that case)
or manually compiled package or some libraries.

# Build from sources
Use **build.sh** to create ISO from scratch<br>
Use **run.sh** to test in under QEMU<br>
Use **iso.sh** to burn ISO to USB flash drive<br>
If something doesn't work, which is very likely to occur, 
watch the tutorials below.

# Tutorials
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/DAXVgdpe7HE/0.jpg)](https://www.youtube.com/watch?v=DAXVgdpe7HE&list=PLLfIBXQeu3aZuc_0xTE2dY3juntHF5xJY&index=2)
