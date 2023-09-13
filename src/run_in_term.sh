#!/bin/bash
qemu-system-x86_64 -nographic -curses --cdrom ../dst/msmd-linux.iso -enable-kvm -m 1G
