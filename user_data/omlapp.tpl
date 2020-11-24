#!/bin/bash

#yum update -y
yum install git -y

sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

echo "clonando el repositorio  de omnileads"
cd /var/tmp
git clone https://gitlab.com/omnileads/ominicontacto.git

cd ominicontacto && git checkout $omnileads_release

echo "inventory setting"
python deploy/vagrant/edit_inventory.py --self_hosted=yes \
  --ami_user=${ami_user} \
  --ami_password=${ami_password} \
  --dialer_user=${dialer_user} \
  --dialer_password=${dialer_password} \
  --ecctl=${ecctl} \
  --postgres_database=${pg_database} \
  --postgres_user=${pg_username} \
  --postgres_password=${pg_password} \
  --rtpengine_host=${rtpengine_host} \
  --sca=${sca} \
  --schedule=${schedule} \
  --TZ=${TZ}
sleep 5

echo "deploy.sh execution"
cd deploy/ansible && ./deploy.sh -i --iface=${NIC}
sleep 5
if [ -d /usr/local/queuemetrics/ ]; then
  systemctl stop qm-tomcat6 && systemctl disable qm-tomcat6
  systemctl stop mariadb && systemctl disable mariadb
fi

echo "digitalocean requiere SSL to connect PGSQL"
echo "SSLMode       = require" >> /etc/odbc.ini


reboot
