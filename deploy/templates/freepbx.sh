#!/bin/bash

setenforce 0
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/selinux/config

dnf -y update && dnf -y group install "Development Tools"

adduser asterisk -m -c "Asterisk User"

firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload

dnf config-manager --set-enabled PowerTools
dnf -y install lynx tftp-server unixODBC mariadb-server mariadb httpd ncurses-devel sendmail sendmail-cf newt-devel libxml2-devel libtiff-devel gtk2-devel subversion git wget vim uuid-devel sqlite-devel net-tools gnutls-devel texinfo libuuid-devel libedit-devel
dnf config-manager --set-disabled PowerTools
dnf install -y http://na.mirror.garr.it/mirrors/MySQL/Downloads/Connector-ODBC/8.0/mysql-connector-odbc-8.0.19-1.el8.x86_64.rpm
dnf install -y epel-release
dnf install -y libid3tag
dnf install -y https://forensics.cert.org/cert-forensics-tools-release-el8.rpm
dnf --enablerepo=forensics install -y sox
dnf install -y audiofile-devel
dnf install -y python3-devel
dnf remove php*
dnf install -y php php-pdo php-mysqlnd php-mbstring php-pear php-process php-xml php-opcache php-ldap php-intl php-soap php-json
curl -sL https://rpm.nodesource.com/setup_12.x | bash -
dnf install -y nodejs

systemctl enable mariadb.service
systemctl start mariadb

systemctl enable httpd.service
systemctl start httpd.service

pear install Console_Getopt

cd /usr/src
wget -O jansson.tar.gz https://github.com/akheron/jansson/archive/v2.12.tar.gz
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-16-current.tar.gz


cd /usr/src
tar vxfz jansson.tar.gz
rm -f jansson.tar.gz
cd jansson-*
autoreconf -i
./configure --libdir=/usr/lib64
make
make install


cd /usr/src
tar xvfz asterisk-16-current.tar.gz
rm -f asterisk-*-current.tar.gz
cd asterisk-*
contrib/scripts/install_prereq install
./configure --libdir=/usr/lib64 --with-pjproject-bundled
contrib/scripts/get_mp3_source.sh

make
make install
make config
make samples
ldconfig
chkconfig asterisk off


chown asterisk. /var/run/asterisk
chown -R asterisk. /etc/asterisk
chown -R asterisk. /var/{lib,log,spool}/asterisk
chown -R asterisk. /usr/lib64/asterisk
chown -R asterisk. /var/www/


sed -i 's/\(^upload_max_filesize = \).*/\120M/' /etc/php.ini
sed -i 's/\(^memory_limit = \).*/\1256M/' /etc/php.ini
sed -i 's/^\(User\|Group\).*/\1 asterisk/' /etc/httpd/conf/httpd.conf
sed -i 's/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf
sed -i 's/\(^user = \).*/\1asterisk/' /etc/php-fpm.d/www.conf
sed -i 's/\(^group = \).*/\1asterisk/' /etc/php-fpm.d/www.conf
sed -i 's/\(^listen.acl_users = apache,nginx\).*/\1,asterisk/' /etc/php-fpm.d/www.conf
systemctl restart httpd.service
systemctl restart php-fpm


cd /usr/src
wget http://mirror.freepbx.org/modules/packages/freepbx/freepbx-15.0-latest.tgz
tar xfz freepbx-15.0-latest.tgz
rm -f freepbx-15.0-latest.tgz
cd freepbx
./start_asterisk start
./install -n
