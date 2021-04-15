#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=develop

export MYSQL_HOST=${mysql_host}
export MYSQL_DB=${mysql_database}
export MYSQL_USER=${mysql_username}
export MYSQL_PASS=${mysql_password}

yum -y install git
cd $SRC
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE

if [[ "$MYSQL_HOST" == "localhost" ]]
then
  chmod +x ./7_mariadb/user_data.sh
  sh ./7_mariadb/user_data.sh
fi

chmod +x ./8_dialer/dialer.sh
sh ./8_dialer/dialer.sh
