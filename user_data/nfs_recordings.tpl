#!/bin/bash

HOST_DIR=/opt/omnileads/asterisk/var/spool/asterisk/monitor
PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)

apt update
apt install nfs-kernel-server -y

echo "/dev/disk/by-id/scsi-0DO_Volume_"${dev_name}" /opt ext4 defaults,nofail,discard,noatime 0 2" >> /etc/fstab

mount /dev/disk/by-id/scsi-0DO_Volume_"${dev_name}" /opt

mkdir -p $HOST_DIR
chown nobody:nogroup $HOST_DIR

echo "$HOST_DIR "${nfs_clients}"(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports

systemctl restart nfs-kernel-server

reboot
