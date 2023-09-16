[![IMAGE ALT TEXT HERE](https://raw.githubusercontent.com/maksimKorzh/msmd-linux/main/img/msmd-linux.png)](https://www.youtube.com/watch?v=EVTw4YqPdKA)

# About
Monkey See, Monkey Do LINUX is a didactic linux distribution serving
educational purposes. It offers a customly configured Linux Kernel,
Glibc, BusyBox, DHCP networking support and BIOS/UEFI boot.

# Project structure
    -> msmd-linux

    ----> cfg                       (         Configuration Files        )
    --------> kernel.config         ( Linux Kernel configuration file    )
    --------> busybox.config        ( BusyBox configuration file         )
    --------> grub.cfg              ( GRUB Bootloader configuration file )

    ----> ini                       (          System Init Files         )
    --------> init                  ( First file Kernel runs on boot     )
    --------> inittab               ( BusyBox /sbin/init configuration   )
    --------> network.sh            ( Script ran by udhcpc on boot       )
    --------> resolv.conf           ( DNS configuration file             )
    --------> wifi.sh               ( Script to connect to WiFi          )
    --------> logo.txt              ( Cute "Monkey See, Monkey Do" logo  )

    ----> src                       (         Distro build script        )
    --------> build_static_core.sh  ( Static MSMD Linux from scratch     )
    --------> build_dynamic_core.sh ( Dynamic MSMD Linux from scratch    )
    --------> remaster_iso.sh       ( Add custom packages to ISO image   )
    --------> run.sh                ( Run MSMD Linux in QEMU             )
    --------> run_in_term.sh        ( Run MSMD Linux in QEMU via ncurses )
    --------> burn.sh               ( Burn ISO to USB flash (/dev/sda)   )

# Download ISO
<a href="https://github.com/maksimKorzh/msmd-linux/releases/download/1/msmd-linux-core-static.iso">**MSMD Linux CORE (static):**</a>
<br>
 - Kernel 5.10.76
 - BusyBox 1.36.1
<br>

<a href="https://github.com/maksimKorzh/msmd-linux/releases/download/1/msmd-linux-core-glibc.iso">**MSMD Linux CORE (glibc):**</a>
<br>
 - Kernel 5.10.76
 - BusyBox 1.36.1

# Remastering ISO
Use **remaster_iso.sh** script to add/remove packages to the RootFS.
By default **msmd-linux-core-glibc.iso** is used as a starter but you can use any.
You can also modify files under **/ini** folder as they would be included.
GRUB config may be altered at **/cfg/grub.cfg**

# WARNING
Make sure to replace **/dev/sda** in **burn.sh** with your own USB device!<br>
OTHERWISE YOU CAN CAUSE IRREVERSIBLE DAMAGE TO YOUR FILES!<br>
Use **sudo fdisk -l** to find your USB flash drive path

# YouTube Tutorials
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/DAXVgdpe7HE/0.jpg)](https://www.youtube.com/watch?v=DAXVgdpe7HE&list=PLLfIBXQeu3aZuc_0xTE2dY3juntHF5xJY&index=2)
