#!/bin/bash

RELEASE=main
OMLCOMP=dialer
OMLDIR=/opt/omnileads/
REPO_DIALER=https://github.com/psychedelicto/oml-dialer
REPO_MYSQL=https://github.com/psychedelicto/oml-mysql

# mysql_host=localhost
# mysql_database=wombat
# mysql_username=wombat
# mysql_password=admin123

yum install -y git

cd /var/tmp
git clone $REPO_DIALER
cd oml-dialer
git checkout $RELEASE
cd ..

if [[ "${mysql_host}" == "localhost" ]]
then
git clone $REPO_MYSQL
chmod +x ./oml-mysql/deploy/onpremise/cloud-init/user_data.sh
sh ./oml-mysql/deploy/onpremise/cloud-init/user_data.sh ${mysql_username} ${mysql_password} ${mysql_host}
fi
chmod +x ./oml-dialer/deploy/digitalocean/cloud-init/install_dialer.sh
sh ./oml-dialer/deploy/digitalocean/cloud-init/install_dialer.sh ${mysql_host} ${mysql_database} ${mysql_username} ${mysql_password}

reboot
