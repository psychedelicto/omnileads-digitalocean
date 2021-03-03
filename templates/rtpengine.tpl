#!/bin/bash

RELEASE=develop

echo "************************* yum update and install kernel-devel ***********************************"
echo "************************* yum update and install kernel-devel ***********************************"
yum update -y && yum install git python3-pip python3 -y
pip3 install pip --upgrade
pip3 install 'ansible==2.9.2'


echo "******************** prereq selinux and firewalld ***************************"
echo "******************** prereq selinux and firewalld ***************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0

echo "************************* Discover IPs ***********************************"
echo "************************* Discover IPs ***********************************"
PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)

echo "******************** Install rtpengine ***************************"
echo "******************** Install rtpengine ***************************"
git clone https://gitlab.com/omnileads/omlrtpengine.git
cd omlrtpengine
git checkout $RELEASE
cd ansible
ansible-playbook rtpengine.yml -i inventory --extra-vars "iface=eth0 rtpengine_version=$(cat ../.rtpengine_version)"

reboot
