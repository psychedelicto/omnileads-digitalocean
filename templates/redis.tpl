#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=onpre-001-oml-2-punto-0

NIC=eth1

export SRC=/usr/src
export PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)
export REDIS_PORT=6379
export COMPONENT_REPO=https://gitlab.com/omnileads/omlredis.git
export COMPONENT_RELEASE=develop

yum -y install git
cd $SRC
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x 1_redis/redis_install.sh
./1_redis/redis_install.sh

rm -rf $SRC/omnileads-onpremise-cluster
rm -rf $SRC/omlredis
