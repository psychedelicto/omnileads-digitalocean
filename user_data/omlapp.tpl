#!/bin/bash

yum update -y
yum install git -y

sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)

echo "${omlapp_hostname}" > /etc/hostname

echo "clonando el repositorio  de omnileads"
cd /var/tmp
git clone https://gitlab.com/omnileads/ominicontacto.git

cd ominicontacto && git checkout ${omnileads_release}

echo "inventory setting"
python deploy/vagrant/edit_inventory.py --self_hosted=yes \
--ami_user=${ami_user} \
--ami_password=${ami_password} \
--dialer_user=${dialer_user} \
--dialer_password=${dialer_password} \
--dialer_host=${dialer_host} \
--mysql_host=${mysql_host} \
--ecctl=${ecctl} \
--postgres_host=${pg_host} \
--postgres_port=${pg_port} \
--postgres_database=${pg_database} \
--postgres_user=${pg_username} \
--postgres_password=${pg_password} \
--default_postgres_database=${pg_default_database} \
--default_postgres_user=${pg_default_user} \
--default_postgres_password=${pg_default_password} \
--redis_host=${redis_host} \
--rtpengine_host=${rtpengine_host} \
--sca=${sca} \
--schedule=${schedule} \
--extern_ip=${extern_ip} \
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


echo "******************** link to recordings device ***************************"
echo "******************** link to recordings device ***************************"
rm -rf /opt/omnileads/asterisk/var/spool/asterisk/monitor
chown  omnileads.omnileads -R /mnt/"${recording_device}"
ln -s /mnt/"${recording_device}"/ /opt/omnileads/asterisk/var/spool/asterisk/monitor
chown omnileads.omnileads -R /opt/omnileads/asterisk/var/spool/

echo "**[omniapp] Instalando sngrep"
yum install ncurses-devel make libpcap-devel pcre-devel \
    openssl-devel git gcc autoconf automake -y
cd /root && git clone https://github.com/irontec/sngrep
cd sngrep && ./bootstrap.sh && ./configure && make && make install
ln -s /usr/local/bin/sngrep /usr/bin/sngrep

reboot
