#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=develop

echo "************************ disable SElinux *************************"
echo "************************ disable SElinux *************************"
echo "************************ disable SElinux *************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0


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

echo "************************ yum install  *************************"
echo "************************ yum install  *************************"
yum install -y python3 python3-pip epel-release git -y

echo "************************ Clone repo and run component install  *************************"
echo "************************ Clone repo and run component install  *************************"
cd $SRC
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x 6_kamailio/kamailio_install.sh
./6_kamailio/kamailio_install.sh

echo "********************************** sngrep SIP sniffer install *********************************"
echo "********************************** sngrep SIP sniffer install *********************************"
yum install ncurses-devel make libpcap-devel pcre-devel \
openssl-devel git gcc autoconf automake -y
cd $SRC && git clone https://github.com/irontec/sngrep
cd sngrep && ./bootstrap.sh && ./configure && make && make install
ln -s /usr/local/bin/sngrep /usr/bin/sngrep

echo "************************ Remove source dirs  *************************"
echo "************************ Remove source dirs  *************************"
rm -rf $SRC/omnileads-onpremise-cluster
rm -rf $SRC/omlkamailio
