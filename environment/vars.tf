variable "region" {
  default = "sfo3"
}
variable "vpc_cidr" {
  default = "172.16.0.0/20"
}
variable "name" {
  default = "terraform-deploy"
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
  default = "s-4vcpu-8gb"
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
variable "tz" {
  default = "America/Argentina/Cordoba"
}
variable "oml_release" {
  default = "release-1.11.7"
}
