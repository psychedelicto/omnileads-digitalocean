#!/bin/bash

HOST_DIR=/opt/omnileads/asterisk/var/spool/asterisk/monitor
PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)

echo "******************** SElinux disable ***************************"
echo "******************** SElinux disable ***************************"
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

echo "******************** yum update and install packages ***************************"
echo "******************** yum update and install packages ***************************"
yum update -y && yum install git nfs-utils python3-pip -y

echo "******************** install ansible ***************************"
echo "******************** install ansible ***************************"
pip3 install --upgrade pip
pip3 install --user 'ansible==2.9.2'



echo "******************** fix hostname and localhost issue on digitalocean ***************************"
echo "******************** fix hostname and localhost issue on digitalocean ***************************"
hostnamectl set-hostname "${omlapp_hostname}"
sed -i 's/127.0.0.1 '${omlapp_hostname}'/#127.0.0.1 '${omlapp_hostname}'/' /etc/hosts
sed -i 's/::1 '${omlapp_hostname}'/#::1 '${omlapp_hostname}'/' /etc/hosts


echo "***************************** git clone omnileads repo ******************************"
echo "***************************** git clone omnileads repo ******************************"
cd /var/tmp
git clone https://gitlab.com/omnileads/ominicontacto.git


echo "***************************** inventory setting *************************************"
echo "***************************** inventory setting *************************************"
cd ominicontacto && git checkout ${omnileads_release}
# git submodule init
# git submodule update
# git submodule update --remote

python ansible/deploy/edit_inventory.py --self_hosted=yes \
--ami_user=${ami_user} \
--ami_password=${ami_password} \
--dialer_user=${dialer_user} \
--dialer_password=${dialer_password} \
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

sleep 2

echo "******************************** deploy.sh execution *******************************"
echo "******************************** deploy.sh execution *******************************"
cd ansible/deploy && ./deploy.sh -i --iface=${NIC}
sleep 5
if [ -d /usr/local/queuemetrics/ ]; then
  systemctl stop qm-tomcat6 && systemctl disable qm-tomcat6
  systemctl stop mariadb && systemctl disable mariadb
fi

echo "***************************** digitalocean requiere SSL to connect PGSQL ***************************"
echo "***************************** digitalocean requiere SSL to connect PGSQL ***************************"
echo "SSLMode       = require" >> /etc/odbc.ini

echo "*********************** S3 recordings ********************************"
echo "*********************** S3 recordings ********************************"
yum install -y s3fs-fuse
echo "${spaces_key}:${spaces_secret_key}" > ~/.passwd-s3fs
chmod 600 ~/.passwd-s3fs
echo "${spaces_bucket_name}:/${spaces_bucket_tenant} $HOST_DIR   fuse.s3fs _netdev,allow_other,use_path_request_style,url=https://sfo3.digitaloceanspaces.com 0 0" >> /etc/fstab
mount -a
chown  omnileads.omnileads -R $HOST_DIR

echo "********************************** sngrep SIP sniffer install *********************************"
echo "********************************** sngrep SIP sniffer install *********************************"
yum install ncurses-devel make libpcap-devel pcre-devel \
    openssl-devel git gcc autoconf automake -y
cd /root && git clone https://github.com/irontec/sngrep
cd sngrep && ./bootstrap.sh && ./configure && make && make install
ln -s /usr/local/bin/sngrep /usr/bin/sngrep

echo "**************************** call recordings on RAMdisk ***************************************"
echo "**************************** call recordings on RAMdisk ***************************************"
echo "**************************** call recordings on RAMdisk ***************************************"

echo "******** 1st: fstab mount RAM ***************************"
echo "tmpfs       /mnt/ramdisk tmpfs   nodev,nosuid,noexec,nodiratime,size=${recording_ramdisk_size}M   0 0" >> /etc/fstab

echo "******** 2nd, mount RAMdisk on file system **************"
mkdir /mnt/ramdisk
mount -t tmpfs -o size=${recording_ramdisk_size}M tmpfs /mnt/ramdisk

echo "******** 3rd: create to move recordings script from RAM to var-spool-asterisk-monitor ***********"
cat > /opt/omnileads/bin/mover_audios.sh <<'EOF'
#!/bin/bash

# RAMDISK Watcher
#
# Revisa el contenido del ram0 y lo pasa a disco duro
## Variables

Ano=$(date +%Y -d today)
Mes=$(date +%m -d today)
Dia=$(date +%d -d today)
LSOF="/sbin/lsof"
RMDIR="/mnt/ramdisk"
ALMACEN="/opt/omnileads/asterisk/var/spool/asterisk/monitor/$Ano-$Mes-$Dia"

if [ ! -d $ALMACEN ]; then
  mkdir -p $ALMACEN;
fi

for i in $(ls $RMDIR/$Ano-$Mes-$Dia/*.wav) ; do
  $LSOF $i &> /dev/null
  valor=$?
  if [ $valor -ne 0 ] ; then
    mv $i $ALMACEN
  fi
done
EOF

echo "********* 4th: set permission and ownership on RAMdisk dir *********"
chown -R omnileads.omnileads /mnt/ramdisk /opt/omnileads/bin/mover_audios.sh
chmod +x /opt/omnileads/bin/mover_audios.sh

echo "********* 5th: change asterisk recordings location to RAM mount disk *************"
sed -i "s/OMLRECPATH=.*/OMLRECPATH=\/mnt\/ramdisk/" /opt/omnileads/asterisk/etc/asterisk/oml_extensions_globals.conf

echo "********* 6th: add cron-line to trigger the call-recording move script *******"
cat > /etc/cron.d/MoverGrabaciones <<EOF
 */1 * * * * omnileads /opt/omnileads/bin/mover_audios.sh
EOF



reboot
