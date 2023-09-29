#!/bin/sh

# Setup networking
for NETDEV in /sys/class/net/* ; do
  sudo ip link set ${NETDEV##*/} up
  [ ${NETDEV##*/} != lo ] && sudo udhcpc -b -i ${NETDEV##*/} -s /etc/network.sh
done
