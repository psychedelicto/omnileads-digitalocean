#!/bin/bash

yum update -y

sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

echo 'tenant1.omlapp' > /etc/hostname
echo '10.120.0.4  pstngw' >> /etc/hosts
echo '10.120.0.5  rtpengine' >> /etc/hosts

reboot
