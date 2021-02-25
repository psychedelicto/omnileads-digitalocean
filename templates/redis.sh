#!/bin/bash

OMLCOMP=redis
RELEASE=main
OMLDIR=/opt/omnileads/

cd /var/tmp
git clone https://github.com/psychedelicto/oml-redis.git
cd oml-redis
git checkout $RELEASE

mkdir -p $OMLDIR/$OMLCOMP
cp ./deploy/common-files/docker-compose.yml $OMLDIR/$OMLCOMP
cp ./deploy/common-files/redis.service /etc/systemd/system

cd $OMLDIR/$OMLCOMP
docker-compose up -d
