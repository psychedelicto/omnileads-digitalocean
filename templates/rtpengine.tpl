#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_BRANCH=onpre-001-oml-2-punto-0

export COMPONENT_REPO=https://gitlab.com/omnileads/omlrtpengine.git
export COMPONENT_RELEASE=omlrtp-001-without-ip-discover
export SRC=/usr/src

yum -y install git curl

########################################## SCENARIO #######################################
# You must to define your scenario to deploy RTPEngine
# LAN if all agents work on LAN netwrok or VPN
# CLOUD if all agents work from the WAN
# HYBRID_1_NIC if some agents work on LAN and others from WAN and the host have ony 1 NIC
# HYBRID_1_NIC if some agents work on LAN and others from WAN and the host have 2 NICs
# (1 NIC for LAN IPADDR and 1 NIC for WAN IPADDR)
export SCENARIO=CLOUD
###########################################################################################

export PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
export PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)

cd $SRC
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_BRANCH
chmod +x 2_rtpengine/rtpengine_install.sh
./2_rtpengine/rtpengine_install.sh

rm -rf $SRC/omnileads-onpremise-cluster
rm -rf $SRC/omlrtpengine
