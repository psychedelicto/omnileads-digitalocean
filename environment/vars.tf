# infra

variable "region" {}
variable "vpc_cidr" {}
variable "domain_name" {}
variable "name" {}
variable "tenant" {}
variable "environment" {}

variable "name_rtpengine" {}
variable "name_pgsql" {}
variable "name_redis" {}
variable "name_mariadb" {}
variable "name_wombat" {}
variable "name_omlapp" {}
variable "name_lb" {}
variable "name_nfs_recordings" {}

variable "app" {}
variable "ssh_id" {}
variable "droplet_oml_size" {}
variable "droplet_rtp_size" {}
variable "droplet_dialer_size" {}
variable "pgsql_size" {}
variable "redis_size" {}
variable "disk_recording_size" {}
variable "recording_ramdisk_size" {}
variable "img_centos" {}
variable "img_ubuntu" {}

# App # App # App

variable "user_data_rtp" {}
variable "user_data_omlapp" {}

variable "sip_allowed_ip" {
  type    = list(string)
}

# OMniLeads deploy vars

variable "oml_tz" {}
variable "oml_release" {}
variable "network_interface" {}
variable "recording_device" {}
variable "omlapp_hostname" {}
variable "ami_user" {}
variable "ami_password" {}
variable "dialer_user" {}
variable "dialer_password" {}
variable "ecctl" {}
variable "pg_database" {}
variable "pg_username" {}
variable "pg_password" {}
variable "sca" {}
variable "schedule" {}
variable "extern_ip" {}


# Wombat dialer
variable "wombat_database" {}
variable "wombat_database_username" {}
variable "wombat_database_password" {}
