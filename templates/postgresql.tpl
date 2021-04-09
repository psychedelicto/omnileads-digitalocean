#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=onpre-001-oml-2-punto-0

PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)
PRIVATE_NETMASK=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/netmask)

export COMPONENT_REPO=https://gitlab.com/omnileads/omlpgsql.git
export COMPONENT_RELEASE=develop

export NIC=eth1
export SOURCE_DIR=/usr/src
export OMLAPP_DB_NAME=${database_name}
export OMLAPP_USERNAME=${omlapp_user}
export OMLAPP_PASSWORD=${omlapp_password}

yum install -y epel-release
yum install -y git ipcalc

export NETADDR_IPV4=$(ipcalc -n $PRIVATE_IPV4 $PRIVATE_NETMASK |cut -d = -f 2)
export NETMASK_PREFIX=$(ipcalc -p $PRIVATE_IPV4 $PRIVATE_NETMASK |cut -d = -f 2)

cd $SOURCE_DIR
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x 3_postgres/postgres_install.sh
./3_postgres/postgres_install.sh

reboot
