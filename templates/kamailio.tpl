#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=onpre-001-oml-2-punto-0

export SRC=/usr/src
export COMPONENT_REPO=https://gitlab.com/omnileads/omlkamailio.git
export COMPONENT_RELEASE=omlkam-001-ajustes-fabi-temp

export NIC=eth1
export PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)
export REDIS_HOST=${redis_host}
export REDIS_PORT=6379
export ASTERISK_HOST=X.X.X.X
export RTPENGINE_HOST=${rtpengine_host}
export KAMAILIO_SHM_SIZE=64
export KAMAILIO_PKG_SIZE=8

yum -y install git
cd $SRC
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x 6_kamailio/kamailio_install.sh
./6_kamailio/kamailio_install.sh

rm -rf $SRC/omnileads-onpremise-cluster
rm -rf $SRC/omlkamailio
