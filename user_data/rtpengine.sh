#!/bin/bash

yum update -y && yum install kernel-devel -y

sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
systemctl disable firewalld

yum install epel-release -y && yum install -y libpcap hiredis xmlrpc-c-client json-glib libevent http://freetech.com.ar/rpms/rtpengine-5.5.3.1-1.x86_64.rpm vim

PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)


echo "OPTIONS="-i $PUBLIC_IPV4  -o 60 -a 3600 -d 30 -s 120 -n $PRIVATE_IPV4:22222 -m 20000 -M 60000 -L 7 --log-facility=local1""  > /etc/rtpengine-config.conf
systemctl enable rtpengine && systemctl start rtpengine

reboot
