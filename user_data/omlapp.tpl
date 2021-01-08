#!/bin/bash

HOST_DIR=/opt/omnileads/asterisk/var/spool/asterisk/monitor

echo "******************** yum update and install prereq ***************************"
echo "******************** yum update and install prereq ***************************"
yum update -y
yum install git nfs-utils -y

echo "******************** disabled selinux ***************************"
echo "******************** disabled selinux ***************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)

echo "******************** set hostname ***************************"
echo "******************** set hostname ***************************"
hostnamectl set-hostname "${omlapp_hostname}"

echo "************************* clonando el repositorio  de omnileads ***********************************"
echo "************************* clonando el repositorio  de omnileads ***********************************"
cd /var/tmp
git clone https://gitlab.com/omnileads/ominicontacto.git
cd ominicontacto && git checkout ${omnileads_release}

echo "********************************************* inventory setting *******************************************"
echo "********************************************* inventory setting *******************************************"
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

echo "****************************** deploy.sh execution *************************************"
echo "****************************** deploy.sh execution *************************************"
cd deploy/ansible && ./deploy.sh -i --iface=${NIC}
sleep 5
if [ -d /usr/local/queuemetrics/ ]; then
  systemctl stop qm-tomcat6 && systemctl disable qm-tomcat6
  systemctl stop mariadb && systemctl disable mariadb
fi

echo "******************** digitalocean requiere SSL to connect PGSQL ************************"
echo "******************** digitalocean requiere SSL to connect PGSQL ************************"
echo "SSLMode       = require" >> /etc/odbc.ini


echo "******************************* NFS fstab *************************************"
echo "******************************* NFS fstab *************************************"
echo ""${nfs_recordings_ip}":$HOST_DIR    $HOST_DIR   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" >> /etc/fstab


echo "***************************** Instalando sngrep ***************************************"
echo "***************************** Instalando sngrep ***************************************"
yum install ncurses-devel make libpcap-devel pcre-devel \
    openssl-devel git gcc autoconf automake -y
cd /root && git clone https://github.com/irontec/sngrep
cd sngrep && ./bootstrap.sh && ./configure && make && make install
ln -s /usr/local/bin/sngrep /usr/bin/sngrep

echo "******************** [asterisk] Pasos para grabaciones en RAMdisk ********************************"
echo "******************** [asterisk] Pasos para grabaciones en RAMdisk ********************************"

echo "************************ [asterisk] Primero: editar el fstab ******************************************"
echo "************************ [asterisk] Primero: editar el fstab ******************************************"
echo "tmpfs       /mnt/ramdisk tmpfs   nodev,nosuid,noexec,nodiratime,size=${recording_ramdisk_size}M   0 0" >> /etc/fstab

echo "*********************** Segundo, creando punto de montaje y montandolo ********************************"
echo "*********************** Segundo, creando punto de montaje y montandolo ********************************"
mkdir /mnt/ramdisk
mount -t tmpfs -o size=${recording_ramdisk_size}M tmpfs /mnt/ramdisk

echo "************************* Segundo: creando script de movimiento de archivos **********************************"
echo "************************* Segundo: creando script de movimiento de archivos **********************************"
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

echo "****************************** [asterisk] Seteando ownership de archivos ************************************"
echo "****************************** [asterisk] Seteando ownership de archivos ************************************"
chown -R omnileads.omnileads /mnt/ramdisk /opt/omnileads/bin/mover_audios.sh
chmod +x /opt/omnileads/bin/mover_audios.sh

echo "****************************** mount NFS for asign omnileads owner ************************************"
echo "****************************** mount NFS for asign omnileads owner ************************************"
mount -t nfs "${nfs_recordings_ip}":$HOST_DIR $HOST_DIR
chown omnileads.omnileads -R $HOST_DIR

echo "******************************** [asterisk] Tercero: seteando el cron para el movimiento de grabaciones *************************************************"
echo "******************************** [asterisk] Tercero: seteando el cron para el movimiento de grabaciones *************************************************"
cat > /etc/cron.d/MoverGrabaciones <<EOF
 */1 * * * * omnileads /opt/omnileads/bin/mover_audios.sh
EOF


reboot
