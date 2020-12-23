# infra

variable "region" {
  default = "sfo3"
}
variable "vpc_cidr" {
  default = "10.16.0.0/20"
}
variable "name" {
  default = "tenant1"
}

variable "tenant" {
  default = "tenant1"
}

variable "environment" {
  default = "develop"
}

variable "name_rtpengine" {
  default = "tenant1-rtp"
}
variable "name_pgsql" {
  default = "tenant1-pgsql"
}
variable "name_redis" {
  default = "tenant1-redis"
}
variable "name_mariadb" {
  default = "tenant1-mariadb"
}
variable "name_wombat" {
  default = "tenant1-wombat"
}
variable "name_omlapp" {
  default = "tenant1-omalapp"
}
variable "name_lb" {
  default = "tenant1-lb"
}


variable "app" {
   default = "omlapp"
}
variable "env" {
  default = "dev"
}
variable "droplet_count" {
  default = 1
}
variable "ssh_id" {
  default = "77:4e:2e:df:2c:9c:42:78:28:a3:e4:49:9f:4f:e6:07"
}
variable "droplet_oml_size" {
  default = "s-2vcpu-2gb"
}
variable "droplet_rtp_size" {
  default = "s-1vcpu-1gb"
}
variable "pgsql_size" {
  default = "db-s-1vcpu-1gb"
}
variable "redis_size" {
  default = "db-s-1vcpu-1gb"
}
variable "disk_size" {
  default = 5
}
variable "img_centos" {
  default = "centos-7-x64"
}
variable "img_ubuntu" {
  default = "ubuntu-18-04-x64"
}

# App # App # App

variable "user_data_rtp" {
  default = "./../user_data/rtpengine.tpl"
}
variable "user_data_omlapp" {
  default = "./../user_data/omlapp.tpl"
}

variable "droplet_name_rtp" {
  default = "rtpengine"
}
variable "droplet_name_omlapp" {
  default = "omlapp"
}
variable "droplet_id" {
  default = "69535713"
}
variable "droplet_slug" {
  default = ""
}

# OMniLeads deploy vars

variable "oml_tz" {
  default = "America/Argentina/Cordoba"
}
variable "oml_release" {
  default = "pre-release-1.12.0"
}
variable "network_interface" {
  default = "eth1"
}
variable "omlapp_hostname" {
  default = "tenant1"
}
variable "ami_user" {
  default = "omnileadsami"
}
variable "ami_password" {
  default = "5_MeO_DMT"
}
variable "dialer_user" {
  default = "demoadmin"
}
variable "dialer_password" {
  default = "demo"
}
variable "ecctl" {
  default = "28800"
}
variable "pg_database" {
  default = "omnileads"
}
variable "pg_username" {
  default = "omnileads"
}
variable "pg_password" {
  default = "098098ZZZ"
}
variable "sca" {
  default = "3600"
}
variable "schedule" {
  default = "agenda"
}
variable "extern_ip" {
  default = "none"
}

# Wombat dialer

variable "wombat_droplet_name" {
  default = "wombat"
}
variable "wombat_database" {
  default = "wombat"
}
variable "wombat_database_username" {
  default = "wombat"
}
variable "wombat_database_password" {
  default = "admin123"
}
