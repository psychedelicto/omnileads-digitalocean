## GENERAL VARS ## GENERAL VARS ## GENERAL VARS
## GENERAL VARS ## GENERAL VARS ## GENERAL VARS

app = "omlapp"
# Environment tag
environment = "staging"
# region
region = "sfo3"
# Your domain name
#domain_name = "sefirot.cloud"
# CentOS-7 image
img_centos = "centos-7-x64"
# Ubuntu Server image
img_ubuntu = "ubuntu-18-04-x64"
# Docker image
img_docker = "docker-20-04"

#spaces_bucket_name = "omnileads"

## SIZING VARS ## SIZING VARS ## SIZING VARS
## SIZING VARS ## SIZING VARS ## SIZING VARS

# OMLapp component droplet size
droplet_oml_size = "s-1vcpu-1gb"
# RTPengine componenet droplet size
droplet_rtp_size = "s-1vcpu-1gb"
# REDIS component droplet size
droplet_redis_size = "s-1vcpu-1gb"
# Wombat dialer component droplet size
droplet_dialer_size = "s-1vcpu-1gb"
# PGSQL component digitalocean-cluster size
pgsql_size = "db-s-1vcpu-1gb"
# RamDisk size MB for OML call recording
recording_ramdisk_size = 200

## COMPONENETS NAME VARS ## COMPONENETS NAME VARS ## COMPONENETS NAME VARS
## COMPONENETS NAME VARS ## COMPONENETS NAME VARS ## COMPONENETS NAME VARS

# Don't change this variables !!!!
# Don't change this variables !!!!
# Don't change this variables !!!!
name = "customer-name"
tenant = "customer-name"
name_rtpengine = "customer-name-rtp"
name_pgsql = "customer-name-pgsql"
name_redis = "customer-name-redis"
name_mariadb = "customer-name-mariadb"
name_wombat = "customer-name-wombat"
name_lb = "customer-name-lb"
name_omlapp = "customer-name-omlapp"
omlapp_hostname = "customer-name-omlapp.sefirot.cloud"
# OMLapp droplet private NIC
network_interface = "eth1"

### OMniLeads App vars ### OMniLeads App vars ### OMniLeads App vars
### OMniLeads App vars ### OMniLeads App vars ### OMniLeads App vars

# OMLApp release to deploy
oml_release = "release-1.13.0"
# Asterisk SIP Trunks allowed ips
sip_allowed_ip = ["142.93.27.10/32"]
# Time Zone to apply on Django
oml_tz = "America/Argentina/Cordoba"


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
