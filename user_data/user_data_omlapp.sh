#!/bin/bash

NIC=eth1 #NET Interface to attach services
omnileads_release="release-1.11.7"  #OMniLeads release to deploy
TZ="America/Argentina/Cordoba"  #Time Zone
sca=1800 # Session cockie age
ami_user=omnileadsami   #Asterisk AMI user
ami_password=5_MeO_DMT  #Asterisk AMI pass
dialer_host=localhost #Wombat dialer location
dialer_user=demoadmin
dialer_password=demo
mysql_host=localhost #DB for wombat dialer
rtpengine_host=10.124.16.2   #RTPengine location
pg_database=omnileads
pg_username=omnileads
pg_password=my_very_strong_pass
pg_host=db_cluster_hostname
pg_port=25060
pg_default_database=defaultdb
pg_default_user=doadmin
pg_default_password=db_cluster_pass


yum update -y && yum install git -y

sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

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

yum install ncurses-devel make libpcap-devel pcre-devel \
    openssl-devel git gcc autoconf automake -y
cd /root && git clone https://github.com/irontec/sngrep
cd sngrep && ./bootstrap.sh && ./configure && make && make install
ln -s /usr/local/bin/sngrep /usr/bin/sngrep

reboot

