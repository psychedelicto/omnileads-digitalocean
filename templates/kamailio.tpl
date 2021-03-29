#!/bin/bash

RELEASE=develop
SRC=/usr/src
PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)


echo "************************ install ansible *************************"
echo "************************ install ansible *************************"
echo "************************ install ansible *************************"
yum update -y
yum install python3 python3-pip epel-release git -y
pip3 install pip --upgrade
pip3 install 'ansible==2.9.2'
export PATH="$HOME/.local/bin/:$PATH"

echo "************************ disable SElinux *************************"
echo "************************ disable SElinux *************************"
echo "************************ disable SElinux *************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0


echo "************************ clone REPO *************************"
echo "************************ clone REPO *************************"
echo "************************ clone REPO *************************"
cd $SRC && git clone https://gitlab.com/omnileads/omlkamailio.git
cd omlkamailio
git checkout $RELEASE
cd ansible

echo "************************ config and install *************************"
echo "************************ config and install *************************"
echo "************************ config and install *************************"
sed -i "s/asterisk_hostname=/asterisk_hostname=x.x.x.x/g" ./inventory
sed -i "s/kamailio_hostname=/kamailio_hostname=$PRIVATE_IPV4/g" ./inventory
sed -i "s/redis_hostname=/redis_hostname=${redis_host}/g" ./inventory
sed -i "s/rtpengine_hostname=/rtpengine_hostname=${rtpengine_host}/g" ./inventory
sed -i "s/shm_size=/shm_size=${kamailio_shm_size}/g" ./inventory
sed -i "s/pkg_size=/pkg_size=${kamailio_pkg_size}/g" ./inventory

ansible-playbook kamailio.yml -i inventory --extra-vars "repo_location=$(pwd)/.. kamailio_version=$(cat ../.package_version)"

echo "********************************** sngrep SIP sniffer install *********************************"
echo "********************************** sngrep SIP sniffer install *********************************"
yum install ncurses-devel make libpcap-devel pcre-devel \
openssl-devel git gcc autoconf automake -y
cd $SRC && git clone https://github.com/irontec/sngrep
cd sngrep && ./bootstrap.sh && ./configure && make && make install
ln -s /usr/local/bin/sngrep /usr/bin/sngrep

reboot
