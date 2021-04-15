#!/bin/bash

PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=develop

export COMPONENT_REPO=https://gitlab.com/omnileads/ominicontacto.git
export COMPONENT_RELEASE=${omnileads_release}
export SRC=/usr/src

export NIC=${NIC}
export TZ=${TZ}
export sca=${sca}
export ami_user=${ami_user}
export ami_password=${ami_password}
export dialer_user=${dialer_user}
export dialer_password=${dialer_password}
export pg_database=${pg_database}
export pg_username=${pg_username}
export pg_password=${pg_password}
export extern_ip=none

if [[ "${pg_host}" != "NULL" ]]; then
export PG_HOST=${pg_host}
fi
if [[ "${pg_port}" != "NULL" ]]; then
export PG_PORT=${pg_port}
fi
if [[ "${kamailio_host}" != "NULL" ]]; then
export KAMAILIO_HOST=${kamailio_host}
fi
if [[ "${rtpengine_host}" != "NULL" ]]; then
export RTPENGINE_HOST=${rtpengine_host}
fi
if [[ "${asterisk_host}" != "NULL" ]]; then
export ASTERISK_HOST=${asterisk_host}
fi
if [[ "${redis_host}" != "NULL" ]]; then
export REDIS_HOST=${redis_host}
fi
if [[ "${dialer_host}" != "NULL" ]]; then
export DIALER_HOST=${dialer_host}
fi
if [[ "${mysql_host}" != "NULL" ]]; then
export MYSQL_HOST=${mysql_host}
fi
if [[ "${websocket_host}" != "NULL" ]]; then
export WEBSOCKET_HOST=${websocket_host}
fi

export ENVIRONMENT_INIT=true

################## UNCOMMENT only if you work with OML-2.0 #####################
if [[ "${omnileads_release}" == "oml-1777-epica-separacion-componentes-oml" ]]; then
  export OML_2=true
  export KAMAILIO_BRANCH=develop
  export ASTERISK_BRANCH=develop
  export RTPENGINE_BRANCH=develop
  export NGINX_BRANCH=develop
  export REDIS_BRANCH=develop
  export POSTGRES_BRANCH=develop
  export WEBSOCKET_BRANCH=develop
fi
################################################################################

echo "******************** SElinux disable ***************************"
echo "******************** SElinux disable ***************************"
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

echo  "**********Digital Ocean and OMniLeads /etc/hosts config *********************"
echo  "**********Digital Ocean and OMniLeads /etc/hosts config *********************"
sed -i 's/127.0.0.1 '$(hostname)'/#127.0.0.1 '$(hostname)'/' /etc/hosts
sed -i 's/::1 '$(hostname)'/#::1 '$(hostname)'/' /etc/hosts

echo "******************** yum update and install packages ***************************"
echo "******************** yum update and install packages ***************************"
yum -y update
yum -y install git python3-pip kernel-devel

echo "******************** run component install ***************************"
echo "******************** run component install ***************************"
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x 9_omlapp/omlapp_install.sh
./9_omlapp/omlapp_install.sh

rm -rf $SRC/omnileads-onpremise-cluster


echo "*********************** S3 call recordings ********************************"
echo "*********************** S3 call recordings ********************************"
yum install -y s3fs-fuse
echo "${spaces_key}:${spaces_secret_key}" > ~/.passwd-s3fs
chmod 600 ~/.passwd-s3fs
echo "${spaces_bucket_name}:/${spaces_bucket_tenant} /opt/omnileads/asterisk/var/spool/asterisk/monitor   fuse.s3fs _netdev,allow_other,use_path_request_style,url=https://sfo3.digitaloceanspaces.com 0 0" >> /etc/fstab
mount -a
chown  omnileads.omnileads -R /opt/omnileads/asterisk/var/spool/asterisk/monitor

echo "********************************** sngrep SIP sniffer install *********************************"
echo "********************************** sngrep SIP sniffer install *********************************"
yum install ncurses-devel make libpcap-devel pcre-devel \
    openssl-devel git gcc autoconf automake -y
cd /root && git clone https://github.com/irontec/sngrep
cd sngrep && ./bootstrap.sh && ./configure && make && make install
ln -s /usr/local/bin/sngrep /usr/bin/sngrep

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
