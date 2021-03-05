#!/bin/bash

yum update -y && yum install git python3-pip python3 -y

pip3 install pip --upgrade
pip3 install 'ansible==2.9.2'

sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

cd /var/tmp
git clone https://gitlab.com/omnileads/omlredis.git
git checkout develop

cd omlredis/ansible
ansible-playbook redis.yml -i inventory --extra-vars "redis_version=$(cat ../.redis_version) redisgears_version=$(cat ../.redisgears_version)"
