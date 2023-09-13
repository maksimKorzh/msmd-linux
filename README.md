[![IMAGE ALT TEXT HERE](https://raw.githubusercontent.com/maksimKorzh/msmd-linux/main/img/msmd-linux.png)](https://www.youtube.com/watch?v=EVTw4YqPdKA)

# About
Monkey See, Monkey Do LINUX is a didactic linux distribution serving
educational purposes. It offers a customly configured Linux Kernel,
statically linked BusyBox, DHCP networking support and BIOS/UEFI boot.

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
    --------> logo.txt              ( Cute "Monkey See, Monkey Do" logo  )

    ----> dst                       (     Distro Files (after build)     )
    --------> iso                   (     ISO folder for remastering     )
    --------> msmd-linux.iso        ( Monkey See, Monkey Do LINUX distro )
    ------------> boot              (           ISO boot files           )
    ----------------> bzImage       ( Compressed Linux Kernel            )
    ----------------> root.cpio.gz  ( Compressed Root File System        )
    ----------------> grub          (       GRUB Bootloader folder       )
    --------------------> grub.cfg  ( GRUB Bootloader config file        )

    ----> src                       (         Distro build script        )
    --------> build_core.sh         ( Build MSMD Linux from scratch      )
    --------> install_packages.sh   ( Add custom packages to distro      )
    --------> remaster_iso.sh       ( Add custom packages to ISO image   )
    --------> run.sh                ( Run MSMD Linux in QEMU             )
    --------> run_in_term.sh        ( Run MSMD Linux in QEMU via ncurses )
    --------> burn.sh               ( Burn ISO to USB flash (/dev/sda)   )

# Installing packages
Distro core produced by the **build_core.sh** is quite basic,
it only has BusyBox and networking support but you cannot retrieve web pages
or download files from the internet via **wget** utility because it depends on **libnss_dns.so** which is
not an option for a statically linked system, so I've provided <a href="https://github.com/maksimKorzh/get">get</a> as a workaround
allowing to download files via modified HTTP client with a custom DNS resolver.
Apart from this you might want to replace BusyBox vi editor with something else
so the need of adding new packages to the distro is arizing naturally.
Usually this is resolved by a package manager, one of the possible options
could be using **static-get** but since it relies on wget/curl it will not work due to the same reasons explained above
and even if it did still the entire system never goes away from the initramfs, so the
changes would not be saved unless you mount a phisical drive and write some files on it,
hence we can take another approach instead: pre-build a set of desired packages "once & forever".
In order to bundle packages into the core you can use **install_packages.sh** script which would
add new packages to the root.cpio.gz if you've compiled msmd-linux from scratch.
The way it works is simple and straight forward - existing rootfs gets unpacked,
new package binary is copied into **/usr/bin** and then rootfs gets packed and copied
into the **dst/iso/boot** folder. After that a new ISO with an updated rootfs is created.
You can also edit **grub.cfg**, e.g. to change the resolution change **set gfxmode-auto** to
**set gfxmode=1024x768x32**, but make make sure the resolution is compatible with your hardware.
Don't forget that you can add only STATICALLY LINKED packages.
You can compile them on your own or use **static-get** to obtain existing ones.

# Remastering ISO
You might get confused by the similarity of **install_packages.sh** and **remaster_iso.sh**
scripts, so here's the difference: **install_packages.sh** should be used when you've built
msmd-linux from sources and want to isntall some packages on top of the core. You can either
run it as is or add some packages on your own. **remaster_iso.sh** is preferred when you
want to to alter the contents of the root file extracted from the downloaded ISO image.
You're free to remove existing packages or add new ones. By default **remaster_iso.sh**
would create the exact copy of the latest release ISO. Read through the script, you'll get where
to copy your custom files to the existing rootfs. Both **install_packages.sh** and **remaster_iso.sh**
would copy all the files from the /ini folder to the ISO image, so you can modify them under /ini
folder instead of doing it inplace (although the latter is also possible)

# Golang & Packages
Although Golang 1.21.0 is now a part of the project, still there are
some limitations, like for instance you can't do a normal **go get package**
again because of the DNS issues, however there're a couple of workarounds: 
you can either remaster ISO with go packages being preinstalled or download
zip file from github and install it to /home/go/src and then to import it
into your project as if it was a standard library. If the package you've
installed has dependencies you need to resolve them manually.

# What is inside ISO?
 - Kernel 5.10.76
 - BusyBox 1.36.1
 - Golang 1.21.0
 - <a href="https://github.com/maksimKorzh/get">get 0.1</a>
 - <a href="https://github.com/maksimKorzh/get">vici 0.3</a>
 - custom shell scripts

# WARNING
Make sure to replace **/dev/sda** in **burn.sh** with your own USB device!<br>
OTHERWISE YOU CAN CAUSE IRREVERSIBLE DAMAGE TO YOUR FILES!<br>
Use **sudo fdisk -l** to figure it out

# Latest release
https://github.com/maksimKorzh/msmd-linux/releases

# YouTube Tutorials
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/DAXVgdpe7HE/0.jpg)](https://www.youtube.com/watch?v=DAXVgdpe7HE&list=PLLfIBXQeu3aZuc_0xTE2dY3juntHF5xJY&index=2)
