# infra

variable "region" {}
variable "vpc_cidr" {}
variable "domain_name" {}
variable "name" {}
variable "tenant" {}
variable "environment" {}

# variable "spaces_endpooint" {}
# variable "aws_s3_region" {}
# variable "spaces_bucket_name" {}
# variable "tfstate_filename" {}
variable "spaces_key" {}
variable "spaces_secret_key" {}

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
variable "droplet_redis_size" {}
variable "pgsql_size" {}
variable "recording_ramdisk_size" {}
variable "img_centos" {}
variable "img_ubuntu" {}

# App # App # App

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
variable "pg_database" {}
variable "pg_username" {}
variable "pg_password" {}
variable "sca" {}
variable "ecctl" {
  default = "28800"
}
variable "schedule" {
  default = "agenda"
}
variable "extern_ip" {
  default = "none"
}


# Wombat dialer
variable "wombat_database" {}
variable "wombat_database_username" {}
variable "wombat_database_password" {}
