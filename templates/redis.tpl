#!/bin/bash

RELEASE=develop
SRC=/usr/src
PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)

echo "************************ install ansible *************************"
echo "************************ install ansible *************************"
echo "************************ install ansible *************************"
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
cd $SRC
git clone https://gitlab.com/omnileads/omlredis.git
cd omlredis
git checkout $RELEASE
cd ansible

echo "************************ config and install *************************"
echo "************************ config and install *************************"
echo "************************ config and install *************************"

ansible-playbook redis.yml -i inventory --extra-vars "redis_version=$(cat ../.redis_version) redisgears_version=$(cat ../.redisgears_version)"
