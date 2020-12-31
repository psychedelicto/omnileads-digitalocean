# infra

# Region to deploy all
region = "sfo3"
app = "omlapp"
# Environment tag
environment = "develop"
# SSH id (take this value from web: Account-Settings-Security)
ssh_id = "77:4e:2e:df:2c:9c:42:78:28:a3:e4:49:9f:4f:e6:07"
# Your domain name
domain_name = "omnileads.cloud"

# OMLapp component droplet size
droplet_oml_size = "s-1vcpu-1gb"
# RTPengine componenet droplet size
droplet_rtp_size = "s-1vcpu-1gb"
# Wombat dialer component droplet size
droplet_dialer_size = "s-1vcpu-1gb"
# REDIS component droplet size
redis_size = "db-s-1vcpu-1gb"
# PGSQL component cluster size
pgsql_size = "db-s-1vcpu-1gb"
# Disk size for OML call recording
disk_recording_size = 5

# CentOS-7 image
img_centos = "centos-7-x64"
# Ubuntu Server image
img_ubuntu = "ubuntu-18-04-x64"

# change "tenant" string for your client name
name = "tenant"
tenant = "tenant"
name_rtpengine = "tenant-rtp"
name_pgsql = "tenant-pgsql"
name_redis = "tenant-redis"
name_mariadb = "tenant-mariadb"
name_wombat = "tenant-wombat"
name_omlapp = "tenant-omlapp"
name_lb = "tenant-lb"

#droplet_count = 1

# App # App # App
# Template to renderized and exec on 1st boot on rtpengine droplet
user_data_rtp = "./../user_data/rtpengine.tpl"
# Template to renderized and exec on 1st boot on omlapp droplet
user_data_omlapp = "./../user_data/omlapp.tpl"


droplet_name_rtp = "rtpengine"
droplet_name_omlapp = "omlapp"

#droplet_id = "69535713"
#droplet_slug = ""
#ssl_cert = "oml-cloud"

# OMniLeads App vars

# Time Zone to apply on Django
oml_tz = "America/Argentina/Cordoba"
# OMLApp release to deploy
oml_release = "pre-release-1.12.0"
# OMLapp droplet private NIC
network_interface = "eth1"
# OMLapp recording dir name
recording_device = "tenant"
# OMLapp droplet hostname
omlapp_hostname = "tenant-omlapp.omnileads.cloud"
# Asterisk AMI USER for OMLApp manager connections
ami_user = "omnileadsami"
# Asterisk AMI PASS for AMI USER OMLApp manager connections
ami_password = "5_MeO_DMT"
# Wombat API user to login from OMLapp
dialer_user = "demoadmin"
# Wombat API password to login from OMLapp
dialer_password = "demo"
# PGSQL database name
pg_database = "omnileads"
# PGSQL username for OMLapp
pg_username = "omnileads"
# PGSQL password for OMLapp
pg_password = "098098ZZZ"
# Session cookie age
sca = "3600"

ecctl = "28800"
schedule = "agenda"
extern_ip = "none"

# Wombat dialer Component vars
wombat_database = "wombat"
wombat_database_username = "wombat"
wombat_database_password = "admin123"
