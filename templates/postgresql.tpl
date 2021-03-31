#!/bin/bash

RELEASE=develop
SRC=/usr/src

PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)
PRIVATE_NETMASK=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/netmask)


echo "************************ install ansible *************************"
echo "************************ install ansible *************************"
echo "************************ install ansible *************************"
yum update -y
yum install python3 python3-pip epel-release git ipcalc -y
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
cd $SRC && git clone https://gitlab.com/omnileads/omlpgsql.git
cd omlpgsql
git checkout $RELEASE
cd ansible

echo "************************ config and install *************************"
echo "************************ config and install *************************"
echo "************************ config and install *************************"
NETADDR_IPV4=$(ipcalc -n $PRIVATE_IPV4 $PRIVATE_NETMASK |cut -d = -f 2)
NETMASK_PREFIX=$(ipcalc -p $PRIVATE_IPV4 $PRIVATE_NETMASK |cut -d = -f 2)

sed -i "s/postgres_database=my_database/postgres_database=${database_name}/g" ./inventory
sed -i "s/postgres_user=my_user/postgres_user=${omlapp_user}/g" ./inventory
sed -i "s/postgres_password=my_very_strong_pass/postgres_password=${omlapp_password}/g" ./inventory
sed -i "s/subnet=X.X.X.X\/XX/subnet=$NETADDR_IPV4\/$NETMASK_PREFIX/g" ./inventory

ansible-playbook postgresql.yml -i inventory --extra-vars "postgresql_version=$(cat ../.postgresql_version)"
