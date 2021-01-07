## GENERAL VARS ## GENERAL VARS ## GENERAL VARS
## GENERAL VARS ## GENERAL VARS ## GENERAL VARS

# Region to deploy all
region = "sfo2"
vpc_cidr = "172.16.16.0/20"
app = "omlapp"
# Environment tag
environment = "staging"
# SSH id (take this value from web: Account-Settings-Security)
ssh_id = "77:4e:2e:df:2c:9c:42:78:28:a3:e4:49:9f:4f:e6:07"
# Your domain name
domain_name = "omnileads.cloud"
# CentOS-7 image
img_centos = "centos-7-x64"
# Ubuntu Server image
img_ubuntu = "ubuntu-18-04-x64"

## SIZING VARS ## SIZING VARS ## SIZING VARS
## SIZING VARS ## SIZING VARS ## SIZING VARS

# OMLapp component droplet size
droplet_oml_size = "s-4vcpu-8gb"
# RTPengine componenet droplet size
droplet_rtp_size = "s-1vcpu-1gb"
# Wombat dialer component droplet size
droplet_dialer_size = "s-1vcpu-1gb"
# REDIS component droplet size
redis_size = "db-s-1vcpu-1gb"
# PGSQL component cluster size
pgsql_size = "db-s-1vcpu-1gb"
# Disk size GB for OML call recording
disk_recording_size = 5
# RamDisk size MB for OML call recording
recording_ramdisk_size = 200

## COMPONENETS NAME VARS ## COMPONENETS NAME VARS ## COMPONENETS NAME VARS
## COMPONENETS NAME VARS ## COMPONENETS NAME VARS ## COMPONENETS NAME VARS

# change "customer" by customer name
name = "konecta"
tenant = "konecta"
name_rtpengine = "konecta-rtp"
name_pgsql = "konecta-pgsql"
name_redis = "konecta-redis"
name_mariadb = "konecta-mariadb"
name_wombat = "konecta-wombat"
name_omlapp = "konecta-omlapp"
name_lb = "konecta-lb"
name_nfs_recordings="konecta-recordings"

### OMniLeads App vars ### OMniLeads App vars ### OMniLeads App vars
### OMniLeads App vars ### OMniLeads App vars ### OMniLeads App vars
# OMLApp release to deploy
oml_release = "pre-release-1.12.0"
# Asterisk SIP Trunks allowed ips
sip_allowed_ip = ["142.93.27.10/32"]
# Time Zone to apply on Django
oml_tz = "America/Argentina/Cordoba"
# OMLapp droplet private NIC
network_interface = "eth1"
# OMLapp recording dir name
recording_device = "oml"
# OMLapp droplet hostname
omlapp_hostname = "konecta-omlapp.omnileads.cloud"
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

# Wombat dialer Component vars
wombat_database = "wombat"
wombat_database_username = "wombat"
wombat_database_password = "admin123"
