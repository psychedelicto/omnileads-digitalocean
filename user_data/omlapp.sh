#!/bin/bash

NIC=eth1
omnileads_release=oml-1819-fix-queue-timeout-0-seg
TZ=America/Argentina/Cordoba
ecctl=2333
sca=1800
oml_hostname=tenant1
ami_user=omnileadsami
ami_password=5_MeO_DMT
dialer_host=localhost
dialer_user=dialer
dialer_password=098098ZZZ
mysql_host=localhost
rtpengine_host=10.120.0.4
pg_port=25060
pg_default_database=defaultdb
pg_default_user=doadmin
pg_database=omnileads
pg_username=omnileads
pg_password=my_very_strong_pass

# private host address and default password of your pgsql cluster database
pg_host=
pg_default_password=


yum update -y
yum install git -y

sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

echo '$oml_hostname' > /etc/hostname
echo '$rtpengine_host  rtpengine' >> /etc/hosts

echo "Clonando el repositorio  de omnileads"
cd /var/tmp
git clone https://gitlab.com/omnileads/ominicontacto.git

cd ominicontacto && git checkout $omnileads_release

echo "inventory setting"
python deploy/vagrant/edit_inventory.py --self_hosted=yes \
  --ami_user=$ami_user \
  --ami_password=$ami_password \
  --dialer_host=$dialer_host \
  --dialer_user=$dialer_user \
  --dialer_password=$dialer_password \
  --ecctl=$ECCTL \
  --mysql_host=$mysql_host \
  --postgres_host=$pg_host \
  --postgres_port=$pg_port \
  --postgres_database=$pg_database \
  --postgres_user=$pg_username \
  --postgres_password=$pg_password \
  --default_postgres_database=$pg_default_database \
  --default_postgres_user=$pg_default_user \
  --default_postgres_password=$pg_default_password \
  --rtpengine_host=$rtpengine_host \
  --sca=$SCA \
  --schedule=$schedule \
  --TZ=$TZ
sleep 10

echo "deploy.sh execution"
cd deploy/ansible && ./deploy.sh -i --iface=$NIC
sleep 5
if [ -d /usr/local/queuemetrics/ ]; then
  systemctl stop qm-tomcat6 && systemctl disable qm-tomcat6
  systemctl stop mariadb && systemctl disable mariadb
fi

echo "digitalocean requiere SSL to connect PGSQL"
echo "SSLMode       = require" >> /etc/odbc.ini


reboot
